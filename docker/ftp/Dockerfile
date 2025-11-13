FROM alpine:latest

RUN apk add --no-cache vsftpd

RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /home/vsftpd/testuser1/upload && \
    adduser -h /home/vsftpd/testuser1 -D -s /bin/false testuser1 && \
    echo "testuser1:test123" | chpasswd && \
    chmod -R 755 /home/vsftpd/testuser1 && \
    chmod 777 /home/vsftpd/testuser1/upload && \
    chmod a-w /home/vsftpd/testuser1

EXPOSE 21 30000-30009

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
