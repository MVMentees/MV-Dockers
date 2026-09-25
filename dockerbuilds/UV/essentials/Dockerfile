# Create Docker image for UniVerse
#
# Use Rocky Linux 9 as the base image
#
FROM rockylinux:9
#
# Update and install basic dependencies
#
RUN echo 'umask 002' > /etc/profile.d/umask.sh && chmod 644 /etc/profile.d/umask.sh
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install \
 	busybox \
        unzip \ 
 	ed \
	libnsl \
	ncurses-compat-libs \
 	gcc \
	openssl-devel \
	bzip2-devel \
	libffi-devel \
	zlib-devel \
	xz-devel \
	make \
	libnsl \
        glibc \
        libaio \
        tar \
        gzip \
        which \
        net-tools \
        vim \
	unixODBC \
	libxcrypt-compat \
	cpio \
	file \
	procps \
        openssh-server \
        iproute \
	cpio \
	diffutils \
        && dnf clean all
#
# Remove to make it smaller, but may be needed for java apps and gui interfaces
#RUN dnf -y install java-1.8.0-openjdk
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
# Copy UniVerse release zip file for install
#
COPY UV*.zip /tmp/.
#
# Create directory in tmp
RUN mkdir -m777 -p /tmp/uvinstall
#
# Add add_users_groups
COPY add_users_groups* /tmp/uvinstall/.
#
# Run install script
COPY UniVerse_install.sh /tmp/uvinstall/.
RUN chmod +x /tmp/uvinstall/UniVerse_install.sh
RUN /tmp/uvinstall/UniVerse_install.sh
#
### add patch for now
#
COPY uvdap_* /usr/uv/bin/.
RUN chmod 755 /usr/uv/bin/uvdap_*
RUN chown uvdb:bin /usr/uv/bin/uvdap_*
#
#
# Copy LESSON_ACCOUNT item and lesson_login to the /usr/uv/bin directory
#
COPY LESSON_ACCOUNT /usr/uv/LESSON_ACCOUNT
COPY lesson_login /usr/uv/bin/lesson_login
RUN chmod 777 /usr/uv/bin/lesson_login
#
# Copy the lesson accounts .tar into the /usr/uv directory
#
COPY lesson.tar.gz /usr/uv/
#
# Start UniVerse service when container runs
#
USER root
CMD ["/usr/uv/bin/lesson_login"]
