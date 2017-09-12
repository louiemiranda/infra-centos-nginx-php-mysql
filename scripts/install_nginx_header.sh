#!/bin/sh

# NGINX_VER=1.12.0
NGINX_VER=1.10.2
HEADERS_MORE_VER=0.32

PWD=`pwd`

cd /usr/local/src
# get nginx source.
wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz
wget https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VER}.tar.gz

tar zxf nginx-${NGINX_VER}.tar.gz
tar zxf v${HEADERS_MORE_VER}.tar.gz
rm -f nginx-${NGINX_VER}.tar.gz v${HEADERS_MORE_VER}.tar.gz
rm -rf headers-more-nginx-module
mv headers-more-nginx-module-${HEADERS_MORE_VER} headers-more-nginx-module

# install dev packages.
yum -y install pcre-devel openssl-devel libxml2-devel libxslt-devel perl-ExtUtils-Embed GeoIP-devel gperftools-devel
# build nginx
cd nginx-${NGINX_VER}
./configure --prefix=/usr/share/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
    --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
    --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
    --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/subsys/nginx \
    --user=nginx \
    --group=nginx \
    --with-file-aio \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_stub_status_module \
    --with-http_perl_module \
    --with-mail_ssl_module \
    --with-pcre \
    --with-google_perftools_module \
    --with-debug \
    --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' \
    --with-ld-opt=' -Wl,-E' \
    --add-module=/usr/local/src/headers-more-nginx-module
make && make install
# restart nginx
/etc/init.d/nginx restart
nginx -V

cd $PWD