#!/bin/sh

# Create ud group and udadm user
  groupadd ud
  useradd -gud udadm
  useradd -gud -G bin user1
  useradd -gud -G bin user2
  useradd -gud -G bin user3

# Set passwords
  echo 'root:root' | chpasswd
  echo 'udadm:udadm' | chpasswd
  echo 'user1:user1' | chpasswd
  echo 'user2:user2' | chpasswd
  echo 'user3:user3' | chpasswd

#
### Add any additional groups/users in users_groups
#
  sed -i '/^[[:space:]]*#/d; s/\r//g; /^$/d' /tmp/udinstall/add_users_groups
  while IFS=: read -r user group; do

    # Handle group-only entries (:group)
    if [ -z "$user" ] && [ -n "$group" ]; then
        getent group "$group" >/dev/null || {
            echo "Adding group $group"
            groupadd "$group"
        }
        continue
    fi

    # Skip empty lines
    [ -z "$user" ] && continue

    #
    # Ensure supplemental group exists if specified
    #
    if [ -n "$group" ] && [ "$group" != "ud" ]; then
        getent group "$group" >/dev/null || {
            echo "Adding group $group"
            groupadd "$group"
        }
    fi

    #
    # Create user if needed with uv as primary group
    #
    if ! id "$user" >/dev/null 2>&1; then
        echo "Adding user $user"

        if [ -n "$group" ] && [ "$group" != "ud" ]; then
            useradd -g ud -G "$group" "$user"
        else
            useradd -g ud "$user"
        fi

        echo "$user:$user" | chpasswd

    #
    # User already exists: add supplemental group if specified
    #
    elif [ -n "$group" ] && [ "$group" != "ud" ]; then
        if ! id -nG "$user" | grep -qw "$group"; then
            echo "Adding $user to group $group"
            usermod -a -G "$group" "$user"
        fi
    fi

  done < /tmp/udinstall/add_users_groups

#
### add .profile to run mypython_login
#
  rm -rf /home/user1/.profile /home/user1/.bash_profile
  echo 'exec /usr/ud83/bin/lesson_login' > /home/user1/.profile
  rm -rf /home/user2/.profile /home/user2/.bash_profile
  echo 'exec /usr/ud83/bin/lesson_login' > /home/user2/.profile
  rm -rf /home/user3/.profile /home/user3/.bash_profile
  echo 'exec /usr/ud83/bin/lesson_login' > /home/user3/.profile

# Create directories and change ownership
  mkdir -p -m777 /usr/ud83/bin /usr/unishared
  chown -R udadm:ud /usr/ud83 /usr/unishared

# Set MALLOC_CHECK to zero per UniData install instructions
  echo export MALLOC_CHECK=0 > /etc/profile.d/malloc.sh
  chmod 755 /etc/profile.d/malloc.sh

# cd to /tmp/udinstall for install
  cd /tmp/udinstall

# Extract items from UniData release zip
  unzip /tmp/UD*.zip

# Install UniData database
  cd /usr/ud83/bin
  tar -xf /tmp/udinstall/bin.tar
  ./udtsetup < /tmp/udinstall/answers.txt




