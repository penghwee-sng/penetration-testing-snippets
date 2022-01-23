#!/bin/bash

process_present() {
    if [ -z "$(pgrep $1)" ]; then
        return 1
    else
        return 0
    fi
}

user_present() {
    if [ -z "$(getent passwd $1)" ]; then
        return 1
    else
        return 0
    fi
}

if [[ $EUID -ne 0 ]]; then
   	echo "Must be run as root."
   	exit 1
else

    # Create www-data group if not present
    if group_present "www-data"; then
        echo "www-data group is present."
    else
        echo "www-data group is not present. Creating..."
        groupadd www-data
    fi
    # Create www-data user if not present
    if user_present "www-data"; then
        echo "www-data user is present."
    else
        echo "www-data user is not present. Creating..."
        useradd -m www-data
        # add www-data to www-data group
        usermod -a -G www-data www-data
    fi
    # Install Apache2-Modsecurity
    if process_present "apache2"; then
        # get APACHE_RUN_USER
        APACHE_RUN_USER=$(grep -Po 'APACHE_RUN_USER=\K[^ ]*' /etc/apache2/envvars)
        # get APACHE_RUN_GROUP
        APACHE_RUN_GROUP=$(grep -Po 'APACHE_RUN_GROUP=\K[^ ]*' /etc/apache2/envvars)
        # Checks if Apache2 is running as root
        if $APACHE_RUN_USER == "root"; then
            # change apache user to www-data
            sed -i 's/APACHE_RUN_USER=root/APACHE_RUN_USER=www-data/g' /etc/apache2/envvars
            # change apache group to www-data
            sed -i 's/APACHE_RUN_GROUP=root/APACHE_RUN_GROUP=www-data/g' /etc/apache2/envvars            
            # loop through all sites in apache2 sites-enabled
            for site in /etc/apache2/sites-enabled/*; do
                # get DocumentRoot from site
                echo $site
                DOCUMENTROOT=$(grep -Po 'DocumentRoot \K[^ ]*' $site)
                # change owner of DOCUMENTROOT to www-data
                chown -R www-data:www-data $DOCUMENTROOT
            done
            service apache2 restart
        fi       

        apt install libapache2-mod-security2 -y
        a2enmod headers
        service apache2 restart
        cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
        sed -i "s/\(SecRuleEngine *\).*/\1On/" /etc/modsecurity/modsecurity.conf
        service apache2 restart
        
        # OWASP CRS
        rm -rf /usr/share/modsecurity-crs
        apt install git -y
        git clone https://github.com/coreruleset/coreruleset /usr/share/modsecurity-crs
        mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
        mv /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

        printf "<IfModule security2_module>\n\tSecDataDir /var/cache/modsecurity\n\tInclude /etc/modsecurity/*.conf\n\tInclude /usr/share/modsecurity-crs/crs-setup.conf\n\tInclude /usr/share/modsecurity-crs/rules/*.conf\n</IfModule>\n" > /etc/apache2/mods-available/security2.conf
        for file in /etc/apache2/sites-enabled/*.conf; do
            sed "/<\/VirtualHost>/i\ \tSecRuleEngine On" "${file}" > "${file}1"
            rm "${file}"
            mv "${file}1" "${file}"
        done
        service apache2 restart
    fi

    # Install Nginx-Modsecurity
    if process_present "nginx"; then
        # get nginx user
        NGINX_USER=$(grep -Po 'user \K[^ ;]*' /etc/nginx/nginx.conf)
        # if NGINX_USER is root
        if $NGINX_USER == "root"; then
            # change nginx user to www-data
            sed -i 's/user root/user www-data/g' /etc/nginx/nginx.conf
            # loop throguh all sites in nginx sites-enabled
            for site in /etc/nginx/sites-enabled/*; do
                # get DocumentRoot from site
                DOCUMENTROOT=$(grep -Po '^\s*root \K[^ ;]*' $site)
                # change owner of DOCUMENTROOT to www-data
                chown -R www-data:www-data $DOCUMENTROOT
            done
            service nginx restart
        fi
        apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev

        #ModSecurity Installation
        cd
        git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity
        cd ModSecurity
        git submodule init
        git submodule update
        ./build.sh
        ./configure
        make
        make install
        cd ..
        rm -rf ModSecurity

        echo -e "${c}Downloading nginx connector for ModSecurity Module"; $r
        cd
        git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

        nginxvnumber=$(nginx -v 2>&1 | grep -o '[0-9.]*')
        echo -e "${c} Current version of nginx is: " $nginxvnumber; $r
        wget http://nginx.org/download/nginx-"$nginxvnumber".tar.gz
        tar zxvf nginx-"$nginxvnumber".tar.gz
        rm -rf nginx-"$nginxvnumber".tar.gz
        cd nginx-"$nginxvnumber"
        ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
        make modules

        mkdir /etc/nginx/additional_modules
        cp objs/ngx_http_modsecurity_module.so /etc/nginx/additional_modules
        sed -i -e '5iload_module /etc/nginx/additional_modules/ngx_http_modsecurity_module.so;\' /etc/nginx/nginx.conf
        (set -x; nginx -t)
        service nginx restart

        mkdir /etc/nginx/modsec
        wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
        wget -P /etc/nginx/modsec/ https://github.com/SpiderLabs/ModSecurity/blob/49495f1925a14f74f93cb0ef01172e5abc3e4c55/unicode.mapping
        mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf

        sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf

        # OWASP CRS
        apt install git -y
        git clone https://github.com/coreruleset/coreruleset /usr/share/modsecurity-crs
        mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
        mv /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

        # Enable modsecurity for all sites
        for file in /etc/nginx/sites-available/*; do
            sed '/^server.*/a \\tmodsecurity on;\n\tmodsecurity_rules_file /etc/nginx/modsec/main.conf;\n' "${file}" > "${file}1"
            rm "${file}"
            mv "${file}1" "${file}"
        done

        # Load rules 
        echo -e "# From https://github.com/SpiderLabs/ModSecurity/blob/master/\n# modsecurity.conf-recommended\n#\n# Edit to set SecRuleEngine On\nInclude \"/etc/nginx/modsec/modsecurity.conf\"\nInclude \"/usr/share/modsecurity-crs/crs-setup.conf\"\nInclude \"/usr/share/modsecurity-crs/rules/*.conf\"\n" > /etc/nginx/modsec/main.conf

        service nginx restart
    fi
    
fi	
