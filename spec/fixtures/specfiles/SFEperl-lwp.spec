%include Solaris.inc

%define build584 0
%define build510 %( if [ -x /usr/perl5/5.10/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build512 %( if [ -x /usr/perl5/5.12/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build516 %( if [ -x /usr/perl5/5.16/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build520 %( if [ -x /usr/perl5/5.20/bin/perl ]; then echo '1'; else echo '0'; fi)
%define include_executable 0

%define cpan_name libwww-perl
%define sfe_cpan_name libwww-perl
%define ips_cpan_name lwp

Summary:               The World-Wide Web library for Perl
Name:                  SFEperl-%{sfe_cpan_name}
IPS_package_name:      library/perl-5/%{ips_cpan_name}
Version:               6.13
IPS_component_version: 6.13
License:               perl_5
URL:                   https://metacpan.org/pod/libwww::perl
Source0:               http://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-%{version}.tar.gz
BuildRoot:             %{_tmppath}/%{name}-%{version}-build

%description
The World-Wide Web library for Perl

%if %{build584}
%package 584
IPS_package_name: library/perl-5/%{ips_cpan_name}-584
Summary:          The World-Wide Web library for Perl
BuildRequires:    runtime/perl-584 = *
BuildRequires:    library/perl-5/extutils-makemaker-584
BuildRequires:    library/perl-5/test-simple-584
Requires:         runtime/perl-584 = *
Requires:         library/perl-5/%{ips_cpan_name}
Requires:         library/perl-5/authen-ntlm-584
Requires:         library/perl-5/digest-md5-584
Requires:         library/perl-5/encode-584
Requires:         library/perl-5/encode-locale-584
Requires:         library/perl-5/file-listing-584
Requires:         library/perl-5/html-parser-584
Requires:         library/perl-5/http-cookies-584
Requires:         library/perl-5/http-daemon-584
Requires:         library/perl-5/http-date-584
Requires:         library/perl-5/http-ghttp-584
Requires:         library/perl-5/http-message-584
Requires:         library/perl-5/http-negotiate-584
Requires:         library/perl-5/http-request-common-584
Requires:         library/perl-5/io-select-584
Requires:         library/perl-5/io-socket-584
Requires:         library/perl-5/lwp-mediatypes-584
Requires:         library/perl-5/lwp-protocol-https-584
Requires:         library/perl-5/mime-base64-584
Requires:         library/perl-5/net-ftp-584
Requires:         library/perl-5/net-http-584
Requires:         library/perl-5/uri-584
Requires:         library/perl-5/www-robotrules-584

%description 584
The World-Wide Web library for Perl
%endif

%if %{build510}
%package 510
IPS_package_name: library/perl-5/%{ips_cpan_name}-510
Summary:          The World-Wide Web library for Perl
BuildRequires:    runtime/perl-510 = *
BuildRequires:    library/perl-5/extutils-makemaker-510
BuildRequires:    library/perl-5/test-simple-510
Requires:         runtime/perl-510 = *
Requires:         library/perl-5/%{ips_cpan_name}
Requires:         library/perl-5/authen-ntlm-510
Requires:         library/perl-5/digest-md5-510
Requires:         library/perl-5/encode-510
Requires:         library/perl-5/encode-locale-510
Requires:         library/perl-5/file-listing-510
Requires:         library/perl-5/html-parser-510
Requires:         library/perl-5/http-cookies-510
Requires:         library/perl-5/http-daemon-510
Requires:         library/perl-5/http-date-510
Requires:         library/perl-5/http-ghttp-510
Requires:         library/perl-5/http-message-510
Requires:         library/perl-5/http-negotiate-510
Requires:         library/perl-5/http-request-common-510
Requires:         library/perl-5/io-select-510
Requires:         library/perl-5/io-socket-510
Requires:         library/perl-5/lwp-mediatypes-510
Requires:         library/perl-5/lwp-protocol-https-510
Requires:         library/perl-5/mime-base64-510
Requires:         library/perl-5/net-ftp-510
Requires:         library/perl-5/net-http-510
Requires:         library/perl-5/uri-510
Requires:         library/perl-5/www-robotrules-510

%description 510
The World-Wide Web library for Perl
%endif

%if %{build512}
%package 512
IPS_package_name: library/perl-5/%{ips_cpan_name}-512
Summary:          The World-Wide Web library for Perl
BuildRequires:    runtime/perl-512 = *
BuildRequires:    library/perl-5/extutils-makemaker-512
BuildRequires:    library/perl-5/test-simple-512
Requires:         runtime/perl-512 = *
Requires:         library/perl-5/%{ips_cpan_name}
Requires:         library/perl-5/authen-ntlm-512
Requires:         library/perl-5/digest-md5-512
Requires:         library/perl-5/encode-512
Requires:         library/perl-5/encode-locale-512
Requires:         library/perl-5/file-listing-512
Requires:         library/perl-5/html-parser-512
Requires:         library/perl-5/http-cookies-512
Requires:         library/perl-5/http-daemon-512
Requires:         library/perl-5/http-date-512
Requires:         library/perl-5/http-ghttp-512
Requires:         library/perl-5/http-message-512
Requires:         library/perl-5/http-negotiate-512
Requires:         library/perl-5/http-request-common-512
Requires:         library/perl-5/io-select-512
Requires:         library/perl-5/io-socket-512
Requires:         library/perl-5/lwp-mediatypes-512
Requires:         library/perl-5/lwp-protocol-https-512
Requires:         library/perl-5/mime-base64-512
Requires:         library/perl-5/net-ftp-512
Requires:         library/perl-5/net-http-512
Requires:         library/perl-5/uri-512
Requires:         library/perl-5/www-robotrules-512

%description 512
The World-Wide Web library for Perl
%endif

%if %{build516}
%package 516
IPS_package_name: library/perl-5/%{ips_cpan_name}-516
Summary:          The World-Wide Web library for Perl
BuildRequires:    runtime/perl-516 = *
BuildRequires:    library/perl-5/extutils-makemaker-516
BuildRequires:    library/perl-5/test-simple-516
Requires:         runtime/perl-516 = *
Requires:         library/perl-5/%{ips_cpan_name}
Requires:         library/perl-5/authen-ntlm-516
Requires:         library/perl-5/digest-md5-516
Requires:         library/perl-5/encode-516
Requires:         library/perl-5/encode-locale-516
Requires:         library/perl-5/file-listing-516
Requires:         library/perl-5/html-parser-516
Requires:         library/perl-5/http-cookies-516
Requires:         library/perl-5/http-daemon-516
Requires:         library/perl-5/http-date-516
Requires:         library/perl-5/http-ghttp-516
Requires:         library/perl-5/http-message-516
Requires:         library/perl-5/http-negotiate-516
Requires:         library/perl-5/http-request-common-516
Requires:         library/perl-5/io-select-516
Requires:         library/perl-5/io-socket-516
Requires:         library/perl-5/lwp-mediatypes-516
Requires:         library/perl-5/lwp-protocol-https-516
Requires:         library/perl-5/mime-base64-516
Requires:         library/perl-5/net-ftp-516
Requires:         library/perl-5/net-http-516
Requires:         library/perl-5/uri-516
Requires:         library/perl-5/www-robotrules-516

%description 516
The World-Wide Web library for Perl
%endif

%if %{build520}
%package 520
IPS_package_name: library/perl-5/%{ips_cpan_name}-520
Summary:          The World-Wide Web library for Perl
BuildRequires:    runtime/perl-520 = *
BuildRequires:    library/perl-5/extutils-makemaker-520
BuildRequires:    library/perl-5/test-simple-520
Requires:         runtime/perl-520 = *
Requires:         library/perl-5/%{ips_cpan_name}
Requires:         library/perl-5/authen-ntlm-520
Requires:         library/perl-5/digest-md5-520
Requires:         library/perl-5/encode-520
Requires:         library/perl-5/encode-locale-520
Requires:         library/perl-5/file-listing-520
Requires:         library/perl-5/html-parser-520
Requires:         library/perl-5/http-cookies-520
Requires:         library/perl-5/http-daemon-520
Requires:         library/perl-5/http-date-520
Requires:         library/perl-5/http-ghttp-520
Requires:         library/perl-5/http-message-520
Requires:         library/perl-5/http-negotiate-520
Requires:         library/perl-5/http-request-common-520
Requires:         library/perl-5/io-select-520
Requires:         library/perl-5/io-socket-520
Requires:         library/perl-5/lwp-mediatypes-520
Requires:         library/perl-5/lwp-protocol-https-520
Requires:         library/perl-5/mime-base64-520
Requires:         library/perl-5/net-ftp-520
Requires:         library/perl-5/net-http-520
Requires:         library/perl-5/uri-520
Requires:         library/perl-5/www-robotrules-520

%description 520
The World-Wide Web library for Perl
%endif


%prep
%setup -q -n %{cpan_name}-%{version}
rm -rf %{buildroot}

%build
build_with_makefile.pl_for() {
    perl_ver=$1
    test=$2
    bindir="/usr/perl5/${perl_ver}/bin"
    vendor_dir="/usr/perl5/vendor_perl/${perl_ver}"

    export PERL5LIB=${vendor_dir}
    ${bindir}/perl Makefile.PL PREFIX=%{_prefix} \
                   DESTDIR=$RPM_BUILD_ROOT \
                   LIB=${vendor_dir}
    make
    [ x${test} = 'xwithout_test' ] || make test
    make pure_install
}

build_with_build.pl_for() {
    perl_ver=$1
    test=$2
    bindir="/usr/perl5/${perl_ver}/bin"
    vendor_dir="/usr/perl5/vendor_perl/${perl_ver}"

    export PERL5LIB=${vendor_dir}
    ${bindir}/perl Build.PL \
                   --installdirs vendor \
                   --destdir $RPM_BUILD_ROOT
    ${bindir}/perl ./Build
    [ x${test} = 'xwithout_test' ] || ${bindir}/perl ./Build test
    ${bindir}/perl ./Build install --destdir $RPM_BUILD_ROOT
}

modify_bin_dir() {
    perl_ver=$1
    if [ -d $RPM_BUILD_ROOT/usr/bin ]
    then
      [ -d $RPM_BUILD_ROOT/usr/perl5/${perl_ver} ] || mkdir -p $RPM_BUILD_ROOT/usr/perl5/${perl_ver}
      mv $RPM_BUILD_ROOT/usr/bin $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/bin
    fi
      
    if [ -d $RPM_BUILD_ROOT/usr/perl5/${perl_ver}bin ]
    then
        for i in $RPM_BUILD_ROOT/usr/perl5/${perl_ver}bin/*
        do
            sed -ibak -e "s/\/usr\/bin\/env ruby/\/usr\/perl5\/${perl-ver}\/bin\/ruby/" ${I}
            [ -f ${i}.bak] || rm ${i}.bak
        done
    fi
}

modify_man_dir() {
    perl_ver=$1
    if [ -d $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/man ]
    then
        if [ -d $RPM_BUILD_ROOT%{_datadir}/man ]
        then
            rm -rf $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/man
        else
            mkdir -p $RPM_BUILD_ROOT%{_datadir}
            mv $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/man $RPM_BUILD_ROOT%{_datadir}/
            rm -rf $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/man
        fi
        rmdir $RPM_BUILD_ROOT/usr/perl5/${perl_ver}
    fi
}

build_for() {
  if [ -f Build.PL ];
  then
    build_with_build.pl_for $*
  elif [ -f Makefile.PL ];
  then
    build_with_makefile.pl_for $*
  fi

  modify_bin_dir $*
  modify_man_dir $*
}

# To build without test, pass 'without_test' to build_for commaond.
# like 'build_for version without_test'
%if %{build584}
build_for 5.8.4 without_test
%endif

%if %{build510}
build_for 5.10 without_test
%endif

%if %{build512}
build_for 5.12 without_test
%endif

%if %{build516}
build_for 5.16 without_test
%endif

%if %{build520}
build_for 5.20 without_test
%endif

%install
if [ -d $RPM_BUILD_ROOT%{_prefix}/man ]
then
    mkdir -p $RPM_BUILD_ROOT%{_datadir}
    mv $RPM_BUILD_ROOT%{_prefix}/man $RPM_BUILD_ROOT%{_datadir}
fi
if [ -d $RPM_BUILD_ROOT%{_datadir}/man/man3 ]
then
    mv $RPM_BUILD_ROOT%{_datadir}/man/man3 $RPM_BUILD_ROOT%{_datadir}/man/man3perl
fi

%clean
rm -rf %{buildroot}

%files
%defattr(0755,root,bin,-)
%{_datadir}/man

%if %{build584}
%files 584
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.8.4
%if %{include_executable}
/usr/perl5/5.8.4
%endif
%endif

%if %{build510}
%files 510
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.10
%if %{include_executable}
/usr/perl5/5.1.0
%endif
%endif

%if %{build512}
%files 512
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.12
%if %{include_executable}
/usr/perl5/5.12
%endif
%endif

%if %{build516}
%files 516
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.16
%if %{include_executable}
/usr/perl5/5.16
%endif
%endif

%if %{build520}
%files 520
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.20
%if %{include_executable}
/usr/perl5/5.20
%endif
%endif


%changelog
* Sun Nov 15 2015 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- build packages for perl-510, perl-516 and perl-520
* Tue Nov 03 2015 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- bump to 6.13
* Wed Jan 23 2013 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- add BuildRequires
* Mon Dec 24 2012 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- add BuildRequires
* Fri Sep 28 2012 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- add Requires
* Wed Sep 26 2012 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- add Requires
* Thu Jun 14 2012 - Fumihisa TONAKA <fumi.ftnk@gmail.com>
- initial commit
