#
# unzip jBASE zip
#
  cd /tmp
  unzip JB*.zip
  chmod +x /tmp/Linux9_j*
#
# Extract install tar to a temp directory
#
  /tmp/Linux9_j*.bin --noexec --keep --target /tmp/jbinstall
#
# get info for setup
  /tmp/Linux9_j*.bin --info > /tmp/jbinstall/awkfile.txt
  setupcmd=`sed -n '/Script run after extraction:/{n;p;}' /tmp/jbinstall/awkfile.txt`
  rm -f /tmp/jbinstall/awkfile.txt
#
# Run setup command
  cd /tmp/jbinstall
#
# If /tmp/jbase_config.json exists, use it otherwise use default from release
#
  if [ -f "/tmp/jbase_config.json" ]; then
    mv /tmp/jbase_config.json ./config/jbase_config.json
  fi
#
# Run setup command unattended
  $setupcmd -- unattended config=./config/jbase_config.json log=/tmp/jbinstall/install.log > /tmp/jbload.log

# Add users
  useradd -gjbase -G bin user1
  useradd -gjbase -G bin user2
  useradd -gjbase -G bin user3

# Set passwords to user name
  echo 'root:root' | chpasswd
  echo 'user1:user1' | chpasswd
  echo 'user2:user2' | chpasswd
  echo 'user3:user3' | chpasswd

#
### Add any additional groups/users in users_groups
#
  sed -i '/^[[:space:]]*#/d; s/\r//g; /^$/d' /tmp/jbinstall/add_users_groups
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
    if [ -n "$group" ] && [ "$group" != "jbase" ]; then
        getent group "$group" >/dev/null || {
            echo "Adding group $group"
            groupadd "$group"
        }
    fi

    #
    # Create user if needed with jbase as primary group
    #
    if ! id "$user" >/dev/null 2>&1; then
        echo "Adding user $user"

        if [ -n "$group" ] && [ "$group" != "jbase" ]; then
            useradd -g jbase -G "$group" "$user"
        else
            useradd -g jbase "$user"
        fi

        echo "$user:$user" | chpasswd

    #
    # User already exists: add supplemental group if specified
    #
    elif [ -n "$group" ] && [ "$group" != "jbase" ]; then
        if ! id -nG "$user" | grep -qw "$group"; then
            echo "Adding $user to group $group"
            usermod -a -G "$group" "$user"
        fi
    fi

  done < /tmp/jbinstall/add_users_groups

#
### add .profile to run lesson_login
#
  rm -rf /home/user1/.profile /home/user1/.bash_profile
  echo 'exec /opt/jbase/CurrentVersion/bin/lesson_login' > /home/user1/.profile
  rm -rf /home/user2/.profile /home/user2/.bash_profile
  echo 'exec /opt/jbase/CurrentVersion/bin/lesson_login' > /home/user2/.profile
  rm -rf /home/user3/.profile /home/user3/.bash_profile
  echo 'exec /opt/jbase/CurrentVersion/bin/lesson_login' > /home/user3/.profile
