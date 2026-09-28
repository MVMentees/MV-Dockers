# Create Docker image for jBASE
#
FROM rockylinux:9
# Update and install basic dependencies
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install \
      procps \
      unzip \
      ncurses \
      busybox \
      compat-openssl11 \
      glibc \
      libaio \
      tar \
      which \
      shadow-utils \
      passwd \
      && dnf clean all
#
# Add stuff for telnet server
#
RUN touch /run/utmp /var/log/wtmp
RUN chgrp utmp /run/utmp /var/log/wtmp || true
RUN chmod 664 /run/utmp /var/log/wtmp
#
# Relax pam_loginuid for container sessions
#
RUN sed -i 's/^\(session.*pam_loginuid\.so.*\)$/# \1/' /etc/pam.d/login || true
#
# Copy jBASE release zip file for install
COPY *.zip /tmp/.
COPY *.bin /tmp/.
#
# Copy config file
COPY jbase_config.json* /tmp/.
#
# Create directory in tmp 
RUN mkdir -m777 -p /tmp/jbinstall
#
# Add add_users_groups
COPY add_users_groups* /tmp/jbinstall/.
#
# Run Install script
COPY jBASE_install.sh /tmp/jbinstall/.
RUN chmod +x /tmp/jbinstall/jBASE_install.sh
RUN /tmp/jbinstall/jBASE_install.sh
#
# Copy LESSON_ACCOUNT item and lesson_login to the /jbasedata directory
#
COPY LESSON_ACCOUNT /jbasedata/.
COPY lesson_login /opt/jbase/CurrentVersion/bin/.
RUN chmod 777 /opt/jbase/CurrentVersion/bin/lesson_login
#
# Copy the lesson accounts .tar into the /jbasedata directory
#
COPY lesson.tar.gz /jbasedata/.
#
# Run jBASE login when container runs
#
USER root
CMD ["/opt/jbase/CurrentVersion/bin/lesson_login"]
