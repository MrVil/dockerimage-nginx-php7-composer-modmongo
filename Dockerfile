FROM ubuntu
ENV ws /var/www/html
WORKDIR ${ws}
RUN apt-get update
RUN apt-get install wget supervisor -y
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
RUN wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -
RUN apt-get update
RUN apt-get install -y git php7.0-fpm nginx zip
RUN apt-get install -y php7.0-mongodb php7.0-xml
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
COPY default /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf   
RUN chown www-data:www-data ${ws} -R

CMD ["/usr/bin/supervisord"]

EXPOSE 80
EXPOSE 443
