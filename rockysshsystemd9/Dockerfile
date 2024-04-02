FROM rockylinux:9

ENV container docker
# systemd
RUN [ ! -f /usr/sbin/init ] && dnf -y install systemd;

# sshd
RUN dnf -y install openssh-server openssh-clients python3 sudo; \
    systemctl enable sshd; \
    systemctl enable systemd-user-sessions.service; \
    dnf clean all

RUN useradd srvadmin -s /usr/bin/bash -G wheel

# entrypoint
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ln -fs /usr/share/zoneinfo/${TIMEZONE} /etc/localtime'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'echo "srvadmin:${ADMIN_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

ENV TIMEZONE Europe/Paris

ENV ROOT_PASSWORD password

ENV ADMIN_PASSWORD password

EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
CMD ["/usr/sbin/init"]