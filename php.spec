%define         app_version   7.1.0RC1
%define         app_prefix    /opt/php
%define         app_user      nobody
%define         app_group     nobody

Name:           php
Version:        %{app_version}
Release:        1%{?dist}
Vendor:         Ryan
Summary:        PHP is an HTML-embedded scripting language.

License:        BSD 
Group: Applications
URL:           http://www.php.net/ 
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

./configure   --prefix=%{app_prefix} --with-config-file-path=%{app_prefix}/etc  --with-config-file-scan-dir  --enable-fpm  --enable-opcache  --enable-sysvsem  --enable-sockets  --enable-pcntl  --enable-mbstring  --enable-mysqlnd  --enable-shmop  --enable-zip  --with-mysqli  --with-freetype-dir  --with-jpeg-dir  --with-png-dir  --with-mcrypt  --with-zlib  --with-curl  --with-pcre-dir  --with-pdo-mysql  --with-gd --enable-gd-native-ttf  --enable-gd-jis-conv  --with-gettext --with-pear --with-libxml-dir  --with-readline 

make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install

cur_dir=`pwd`

cd $RPM_BUILD_ROOT && (find . -type f | sed -e 's|^./|/|g' > $cur_dir/%{name}.manifest)
cd $RPM_BUILD_ROOT && (find . -type l | sed -e 's|^./|/|g' >> $cur_dir/%{name}.manifest)


%pre 

%post

%preun

%postun


%clean
rm -rf $RPM_BUILD_ROOT

%files -f %{name}.manifest
%defattr(-,%{app_user},%{app_group},-)
%doc
%dir %{app_prefix}

%config(noreplace) %{app_prefix}/etc/php-fpm.conf
%config(noreplace) %{app_prefix}/etc/php-fpm.d/www.conf

%{app_prefix}

%changelog
