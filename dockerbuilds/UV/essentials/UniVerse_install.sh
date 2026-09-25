#!/bin/sh

# Create ud group and udadm user
  echo "Creating uv group and base users"
  groupadd uv
  useradd -guv uvadm
  useradd -guv uvdb
  useradd -guv user1
  useradd -guv user2
  useradd -guv user3

# Set passwords
  echo "Setting password for base users"
  echo 'root:root' | chpasswd
  echo 'uvadm:uvadm' | chpasswd
  echo 'uvdb:uvdb' | chpasswd
  echo 'user1:user1' | chpasswd
  echo 'user2:user2' | chpasswd
  echo 'user3:user3' | chpasswd

#
### Add any additional groups/users in users_groups
#
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
    if [ -n "$group" ] && [ "$group" != "uv" ]; then
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

        if [ -n "$group" ] && [ "$group" != "uv" ]; then
            useradd -g uv -G "$group" "$user"
        else
            useradd -g uv "$user"
        fi
  
        rm -rf /home/user1/.profile /home/$user/.bash_profile
        echo 'exec /usr/uv/bin/lesson_login' > /home/$user/.profile

        echo "$user:$user" | chpasswd

    #
    # User already exists: add supplemental group if specified
    #
    elif [ -n "$group" ] && [ "$group" != "uv" ]; then
        if ! id -nG "$user" | grep -qw "$group"; then
            echo "Adding $user to group $group"
            usermod -a -G "$group" "$user"
        fi
    fi

  done < /tmp/uvinstall/add_users_groups

#
### add .profile to run lesson_login
#
  echo "Adding .profile for users"
  rm -rf /home/user1/.profile /home/user1/.bash_profile
  echo 'exec /usr/uv/bin/lesson_login' > /home/user1/.profile
  rm -rf /home/user2/.profile /home/user2/.bash_profile
  echo 'exec /usr/uv/bin/lesson_login' > /home/user2/.profile
  rm -rf /home/user3/.profile /home/user3/.bash_profile
  echo 'exec /usr/uv/bin/lesson_login' > /home/user3/.profile

# Create directories for database and change ownership
  mkdir -m777 /usr/uv /usr/unishared 
  chown uvadm:uv /usr/uv /usr/unishared 

# cd to /tmp/uvinstall for install
  cd /tmp/uvinstall

# Extract items from UniVerse release zip
  unzip /tmp/UV*.zip

# Extract uv.log to install UniVerse database
  cpio -ivcBdum uv.load < ./STARTUP
  chown uvadm:uv uv.load

# Run uv.load as uvadm
  su - uvadm -c "cd /tmp/uvinstall && printf '\n\n' | ./uv.load"

# Finish install as root
  printf '\equit\r' | /usr/uv/uv.install
