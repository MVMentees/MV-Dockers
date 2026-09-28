
# Use Rocky Linux 9 as the base image
FROM rockylinux:9

# Set environment variables
ENV UDTHOME=/usr/ud83
ENV LANG=C
ENV LC_ALL=C

# Update and install basic dependencies
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install \
        unzip \
        ncurses \
        busybox \
        glibc \
        libaio \
        tar \
        gzip \
        which \
        net-tools \
        vim \
	libnsl \
	unixODBC \
	libxcrypt-compat \
	cpio \
	file \
	procps \
        openssh-server \
        iproute \
        && dnf clean all
#
# Add stuff for telnet server to work in docker
#
RUN touch /run/utmp /var/log/wtmp
RUN chgrp utmp /run/utmp /var/log/wtmp || true
RUN chmod 664 /run/utmp /var/log/wtmp
#
# Relax pam_loginuid for container sessions
#
RUN sed -i 's/^\(session.*pam_loginuid\.so.*\)$/# \1/' /etc/pam.d/login || true
#
# Copy UniData release zip file for install
#
COPY UD*.zip /tmp/.
#
### Create directory in tmp 
#
RUN mkdir -m777 -p /tmp/udinstall
#
# Add add_users_groups
COPY add_users_groups* /tmp/udinstall/.
#
# Run install script
COPY UniData_install.sh /tmp/udinstall/UniData_install.sh
COPY answers.txt /tmp/udinstall/answers.txt
RUN chmod +x /tmp/udinstall/UniData_install.sh
RUN /tmp/udinstall/UniData_install.sh
#
# Copy LESSON_ACCOUNT item and lesson_login to the /usr/uv/bin directory
#
COPY LESSON_ACCOUNT /usr/ud83/LESSON_ACCOUNT
COPY lesson_login /usr/ud83/bin/lesson_login
RUN chmod 777 /usr/ud83/bin/lesson_login
#
# Copy the lesson accounts .tar into the /usr/uv directory
#
COPY lesson.tar.gz /usr/ud83/
#
# Start UniDate service when container runs
#
USER root
CMD ["/usr/ud83/bin/lesson_login"]

