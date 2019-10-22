
FROM ohiosupercomputer/ood:latest

HTTPD_DB="/opt/rh/httpd24/root/etc/httpd/.htpasswd"

RUN userdel ood
RUN groupadd $USER
RUN useradd -u $(id -u) --create-home --gid $USER $USER
RUN userdel ood
RUN groupadd $USER
RUN useradd -u $(id -u) --create-home --gid $USER $USER
RUN usermod -a -G wheel $USER
RUN passwd --delete $USER
RUN passwd --delete root
RUN scl enable httpd24 -- /opt/rh/httpd24/root/etc/httpd/.htpasswd -b -c $HTTPD_DB $USER $USER

