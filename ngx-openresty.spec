%define         resty_prefix    /opt/ngx-openresty/
%define         resty_user      nobody
%define         resty_group     nobody

Name:           ngx-openresty
Version:        x.y.z 
Release:        1%{?dist}
Vendor:         Ryan
Summary:        Openresty - Turning Nginx into a Full-Fledged Scriptable Web Platform 

License:        BSD 
Group: Applications
URL:           http://www.openresty.org/ 
Source0:        %{name}-%{version}.tar.gz 

BuildRequires:	gcc >= 3.0, openssl-devel, pcre-devel, readline-devel
Requires:      readline, pcre, openssl

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}

%description
OpenResty is a full-fledged web application server by bundling the standard Nginx core, lots of 3rd-party Nginx modules, as well as most of their external dependencie

%prep
%setup -q -n %{name}-%{version}


%build

./configure --prefix=%{resty_prefix} \
            --with-http_postgres_module \
            --with-pcre-jit \
            --with-ipv6 \
            --without-http_redis2_module \
            --with-http_iconv_module \
            --with-http_postgres_module \
            --with-http_v2_module \
            --with-luajit \
            --with-openssl=./openssl-1.0.2f \
            --with-pcre=./pcre-8.39 \
            -j4 \

make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install

cur_dir=`pwd`

cd $RPM_BUILD_ROOT%{resty_prefix}/nginx/ && \
    mkdir client_body_temp fastcgi_temp proxy_temp

cd $RPM_BUILD_ROOT && (find . -type f | sed -e 's|^./|/|g' > $cur_dir/%{name}.manifest)
cd $RPM_BUILD_ROOT && (find . -type l | sed -e 's|^./|/|g' >> $cur_dir/%{name}.manifest)

echo %{resty_prefix}/nginx/logs >> $cur_dir/%{name}.manifest
echo %{resty_prefix}/nginx/client_body_temp >> $cur_dir/%{name}.manifest
echo %{resty_prefix}/nginx/fastcgi_temp >> $cur_dir/%{name}.manifest
echo %{resty_prefix}/nginx/proxy_temp >> $cur_dir/%{name}.manifest

%pre 

%post

%preun

%postun


%clean
rm -rf $RPM_BUILD_ROOT

%files -f %{name}.manifest
%defattr(-,%{resty_user},%{resty_group},-)
%doc
%dir %{resty_prefix}

%config(noreplace) %{resty_prefix}/nginx/conf/*.conf

%{resty_prefix}

%changelog
