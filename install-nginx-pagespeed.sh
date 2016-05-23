#!/bin/bash
# (c) by ecm4u GmbH
# Author Heiko Robert <heiko.robert@ecm4u.de>


# s. https://developers.google.com/speed/pagespeed/module/build_ngx_pagespeed_from_source

#sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip
#sudo apt-get install libxml2-dev libxslt-dev libgd2-xpm-dev libgeoip-dev libssl-dev

NGINX_BUILD_OPTS="--http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_spdy_module --with-http_sub_module --with-http_xslt_module --with-mail --with-mail_ssl_module"
NPS_VERSION=1.9.32.3
NGINX_VERSION=1.7.12

#///////////////////////////  don't change after this line //////////////////////////////

USER_ID=`id -u`

if [[ "$USER_ID" != "0" ]]
then
  echo "$0: You must run this script as root: $USER_ID"
  exit 1
fi



cd
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/

cd
# check http://nginx.org/en/download.html for the latest version
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --add-module=$HOME/ngx_pagespeed-release-${NPS_VERSION}-beta --prefix=/usr/local/share/nginx --conf-path=/etc/nginx/nginx.conf --sbin-path=/usr/local/sbin --error-log-path=/var/log/nginx/error.log $NGINX_BUILD_OPTS
make
sudo make install


# cp /etc/init.d/nginx /etc/init.d/nginx-pagespeed
# sed -i 's|/usr/sbin/nginx|/usr/local/sbin/nginx|g' /etc/init.d/nginx-pagespeed
