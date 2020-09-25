#Auther: superwen

FROM  centos:7.8.2003

RUN yum install -y wget 
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -O /etc/yum.repos.d/CentOS7-Base-163.repo
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum clean all && yum -y update \
    && yum install -y gcc gcc-c++ python3 yum-utils libjpeg libjpeg-devel libpng-devel freetype freetype-devel \
    && yum-config-manager --enable remi-php73 \
    && yum install -y nginx supervisord php php-devel php-fpm php-pdo php-pdo_mysql php-pear phpmbstring php-mcrypt php-devel php-cli php-gd php-pear php-curl php-mysql php-ldap php-zip php-fileinfo 

COPY ./configs/php7.3.ini /etc/php.ini
COPY ./configs/www.conf /etc/php-fpm.d/www.conf
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/app.conf /etc/nginx/sites-enabled/app.conf
COPY ./supervisord.conf /etc/supervisor/conf.d/
COPY ./app /var/www/app/

WORKDIR /var/www/app/
EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
