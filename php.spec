%define         app_version   7.1.3
%define         app_prefix    /opt/php7
%define         app_user      www
%define         app_group     www

Name:           php
Version:        %{app_version}
Release:        1%{?dist}
Vendor:         Ryan
Summary:        PHP: Hypertext Preprocessor

License:        BSD 
Group:          Development/Languages
URL:            http://www.php.net/ 
Source0:        %{name}-%{version}.tar.gz 

BuildRequires:	gcc >= 3.0, openssl-devel, pcre-devel, readline-devel,libcurl-devel,libpng-devel,libxml2-devel,glibc-devel,freetype-devel,libstdc++-devel,xz-devel,zlib-devel,keyutils-libs-devel,krb5-devel,libcom_err-devel,libselinux-devel,libsepol-devel,libverto-devel,ncurses-devel,libjpeg-turbo-devel,postgresql-devel
Requires:      gcc-c++, make, cpp, freetype, gcc, glibc-headers, kernel-headers, libmpc, libpng, mpfr, perl, libjpeg-turbo

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}

%description
        PHP is an HTML-embedded scripting language. Much of its syntax is
        borrowed from C, Java and Perl with a couple of unique PHP-specific
       features thrown in. The goal of the language is to allow web
        developers to write dynamically generated pages quickly.

%prep
%setup -q -n %{name}-%{version}


%build

./configure   --prefix=%{app_prefix} --with-config-file-path=%{app_prefix}/etc  --with-config-file-scan-dir  --enable-fpm  --enable-opcache  --enable-sysvsem  --enable-sockets  --enable-pcntl  --enable-mbstring  --enable-mysqlnd  --enable-shmop  --enable-zip  --with-mysqli  --with-freetype-dir  --with-jpeg-dir  --with-png-dir  --with-mcrypt  --with-zlib  --with-curl  --with-pcre-dir  --with-pdo-mysql  --with-gd --enable-gd-native-ttf  --enable-gd-jis-conv  --with-gettext --with-pear --with-libxml-dir  --with-readline --with-openssl

make %{?_smp_mflags}
#make %{?_smp_mflags} PREFIX=%{buildroot}%{app_prefix}


%install 

%make_install 
#make install INSTALL_ROOT=%{buildroot}
#make install INSTALL_ROOT=$RPM_BUILD_ROOT

[ -d /etc/php-fpm.d  ] || %{__install} -d -m 0644 %{_sysconfdir}/php-fpm.d
%{__install} -p -m 0644 %{buildroot}%{app_prefix}/etc/php-fpm.conf.default %{buildroot}%{app_prefix}/etc/php-fpm.conf
%{__install} -p -m 0644 %{buildroot}%{app_prefix}/etc/php-fpm.d/www.conf.default %{buildroot}%{app_prefix}/etc/php-fpm.d/www.conf
sed -i 's/^user\ =\ nobody/user\ =\ %{app_user}/g'  %{buildroot}%{app_prefix}/etc/php-fpm.d/www.conf 2>&1 >/dev/null &
sed -i 's/^group\ =\ nobody/group\ =\ %{app_group}/g'  %{buildroot}%{app_prefix}/etc/php-fpm.d/www.conf 2>&1 >/dev/null &

%pre
getent group %{app_group} 2>&1 >/dev/null || groupadd %{app_group}
getent passwd %{app_user} 2>&1 >/dev/null || useradd -c %{app_user} -g %{app_group} -M -s /usr/sbin/nologin %{app_user}

%post 

killall php-fpm 2>&1 >/dev/null &
sleep 1
%{app_prefix}/sbin/php-fpm -D 2>&1 >/dev/null &

%preun 
if [ $1 -eq 0 ]; then 
    killall php-fpm 2>&1 >/dev/null &
fi

%postun

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,%{app_user},%{app_group},-)
%doc

%{app_prefix}
/.channels
/.depdb
/.depdblock
/.filemap
/.lock


%config %{app_prefix}/etc/pear.conf
%config(noreplace) %{app_prefix}/etc/php-fpm.conf
%config(noreplace) %{app_prefix}/etc/php-fpm.d/www.conf 

%changelog
