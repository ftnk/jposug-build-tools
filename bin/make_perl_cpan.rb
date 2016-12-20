#!/usr/bin/ruby
# -*- coding: utf-8 -*-
=begin
make_perl_cpan_spec.rb

Perl CPAN module 用の spec file を生成する。

usage: make_perl_cpan_spec.rb module

=end

require 'open-uri'
require 'json'
require 'erb'
require 'pp'

API_ENDPOINT = 'http://api.metacpan.org/v0/release/'

MODULE_MAP = {
  # 'file-temp' => 'perl',
  'app-prove' => 'test-harness',
  'authen-ntml' => 'ntlm',
  'authen-simple-passwd' => 'authen-simple',
  'b' => 'perl',
  'b-deparse' => 'perl',
  'base' => 'perl',
  'blib' => 'perl',
  'bytes' => 'perl',
  'class-accessor-fast' => 'class-accessor',
  'class-mop-class' => 'moose',
  'config' => 'perl',
  'cpan-meta-prereqs' => 'cpan-meta',
  'cwd' => 'pathtools',
  'devel-peek' => 'perl',
  'digest-base' => 'digest',
  'digest-hmac_md5' => 'digest-hmac',
  'dynaloader' => 'perl',
  'encode-alias' => 'encode',
  'encode-mime-header' => 'encode',
  'errno' => 'perl',
  'extutils-embed' => 'perl',
  'extutils-installed' => 'extutils-install',
  'fields' => 'base',
  'file-basename' => 'perl',
  'file-compare' => 'perl',
  'file-copy' => 'perl',
  'file-find' => 'perl',
  'file-glob' => 'perl',
  'file-spec' => 'pathtools',
  'file-spec-functions' => 'pathtools',
  'file-stat' => 'perl',
  'filehandle' => 'perl',
  'findbin' => 'perl',
  'html-entities' => 'html-parser',
  'html-headparser' => 'html-parser',
  'http-entity-parser-urlencode' => 'http-entity-parser',
  'http-headers' => 'http-message',
  'http-message-psgi' => 'plack',
  'http-request' => 'http-message',
  'http-request-common' => 'http-message',
  'http-response' => 'http-message',
  'http-server-simple-cgi' => 'http-server-simple',
  'http-status' => 'http-message',
  'i18n-langinfo' => 'perl',
  'if' => 'perl',
  'io-dir' => 'io',
  'io-file' => 'io',
  'io-handle' => 'io',
  'io-pty' => 'io-tty',
  'io-socket' => 'io',
  'io-socket-inet' => 'io',
  'ipc-open2' => 'perl',
  'ipc-open3' => 'perl',
  'lib' => 'perl',
  'list-util' => 'scalar-list-utils',
  'lwp-simple' => 'lwp',
  'lwp-useragent' => 'lwp',
  'metaclasse' => 'moose',
  'moo-role' => 'moo',
  'moose-exporter' => 'moose',
  'moose-role' => 'moose',
  'moose-util-typeconstraints' => 'moose',
  'mouse-role' => 'mouse',
  'open' => 'perl',
  'overload' => 'perl',
  'plack-middleware-static' => 'plack',
  'plack-request' => 'plack',
  'pod-man' => 'podlators',
  'posix' => 'perl',
  'ppi-document' => 'ppi',
  'ppi-document-file' => 'ppi',
  'ppi-dumper' => 'ppi',
  'ppi-node' => 'ppi',
  'ppi-token-quote-single' => 'ppi',
  'ppi-token-whitespace' => 'ppi',
  'ppix-utilities-node' => 'ppix-utilities',
  'ppix-utilities-statement' => 'ppix-utilities',
  'scalar-util' => 'scalar-list-utils',
  'strict' => 'perl',
  'subs' => 'perl',
  'symbol' => 'perl',
  'sys-hostname' => 'perl',
  'tap-harness-env' => 'test-harness',
  'test' => 'perl',
  'test-builder' => 'test-simple',
  'test-builder-module' => 'test-simple',
  'test-builder-tester' => 'test-simple',
  'test-moose' => 'moose',
  'test-more' => 'test-simple',
  'test-tester' => 'test-simple',
  'test-use-ok' => 'test-simple',
  'tie-array' => 'perl',
  'tie-hash' => 'perl',
  'time-zone' => 'timedate',
  'uri-escape' => 'uri',
  'utf8' => 'perl',
  'vars' => 'perl',
  'warnings' => 'perl',
  'yaml-xs' => 'yaml-libyaml',
  'file-spec-unix' => 'pathtools',
  'role-tiny-witn' => 'role-tiny',
  'pod-eventual-simple' => 'pod-eventual',
  'fcntl' => 'perl',
  'software-licenseutils' => 'software-license',
  'software-license-cc_by_sa_3_0' => 'software-license-ccpack',
  'mixin-linewise-readers' => 'mixin-linewise',
  'net-emptyport' => 'test-tcp',
}

def usage()
  puts "usage: #{File.basename($0)} gemname"
end

def normalize_requires(array)
  array.map!{ |i| i['module'].downcase.gsub(/::/, '-') }
  requires = []
  array.each do |req|
    if MODULE_MAP[req]
      requires << MODULE_MAP[req]
    else
      requires << req
    end
  end
  requires = requires.sort.uniq
  requires.delete('perl')
  return requires
end

def find_build_requires(data)
  breq = data['dependency'].find_all{ |i| /(build|test|configure)/ =~ i['phase'] }
  return normalize_requires(breq)
end

def find_runtime_requires(data)
  req = data['dependency'].find_all{ |i| i['phase'] == 'runtime'}
  return normalize_requires(req)
end

unless ARGV.size == 1
  usage
  exit 1
end

cpan_module = ARGV.shift

specfile = "SFEperl-#{cpan_module.downcase.gsub(/::/, '-')}.spec"
if File.exist?(specfile)
  STDERR.puts "file alerady exists. #{specfile}"
  exit 1
end

puts "get CPAN module information: #{cpan_module}"
cpan_module = cpan_module.gsub(/::/, '-')
json = open("#{API_ENDPOINT}/#{cpan_module}").read
data = JSON.load(json)

data[:build_requires] = find_build_requires(data)
data[:runtime_requires] = find_runtime_requires(data)

puts "output: #{specfile}"
File.open(specfile, 'w').puts ERB.new(DATA.read, nil, '-').result(binding)

__END__
%include Solaris.inc

%define build584 0
%define build510 %( if [ -x /usr/perl5/5.10/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build512 %( if [ -x /usr/perl5/5.12/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build516 %( if [ -x /usr/perl5/5.16/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build520 %( if [ -x /usr/perl5/5.20/bin/perl ]; then echo '1'; else echo '0'; fi)
%define build522 %( if [ -x /usr/perl5/5.22/bin/perl ]; then echo '1'; else echo '0'; fi)
%define include_executable 0

%define cpan_name <%= data['distribution'] %>
%define sfe_cpan_name <%= data['distribution'].downcase.gsub(/(::|_)/, '-') %>
%define ips_cpan_name <%= data['distribution'].downcase.gsub(/::/, '-') %>

Summary:               <%= data['abstract'] %>
Name:                  SFEperl-%{sfe_cpan_name}
IPS_package_name:      library/perl-5/%{ips_cpan_name}
Version:               <%= data['version'].to_s %>
IPS_component_version: <%= data['version'].to_s.split('.').map{ |i| i.gsub(/^0*([1-9][0-9]*|0)/, '\1') }.join('.') %>
License:               <%= data['license'][0] %>
URL:                   https://metacpan.org/pod/<%= data['distribution'].gsub(/-/, '::') %>
Source0:               <%= data['download_url'].sub(/#{data['version']}/, '%{version}').sub(/^https/, 'http') %>
BuildRoot:             %{_tmppath}/%{name}-%{version}-build

%description
<%= data['abstract'] %>

%if %{build584}
%package 584
IPS_package_name: library/perl-5/%{ips_cpan_name}-584
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-584 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-584
<% end -%>
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-584
<% end -%>
Requires:         runtime/perl-584 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-584
<% end -%>

%description 584
<%= data['abstract'] %>
%endif

%if %{build510}
%package 510
IPS_package_name: library/perl-5/%{ips_cpan_name}-510
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-510 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-510
<% end -%>
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-510
<% end -%>
Requires:         runtime/perl-510 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-510
<% end -%>

%description 510
<%= data['abstract'] %>
%endif

%if %{build512}
%package 512
IPS_package_name: library/perl-5/%{ips_cpan_name}-512
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-512 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-512
<% end -%>
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-512
<% end -%>
Requires:         runtime/perl-512 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-512
<% end -%>

%description 512
<%= data['abstract'] %>
%endif

%if %{build516}
%package 516
IPS_package_name: library/perl-5/%{ips_cpan_name}-516
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-516 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-516
<% end -%>
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-516
<% end -%>
Requires:         runtime/perl-516 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-516
<% end -%>

%description 516
<%= data['abstract'] %>
%endif

%if %{build520}
%package 520
IPS_package_name: library/perl-5/%{ips_cpan_name}-520
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-520 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-520
<% end -%>
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-520
<% end -%>
Requires:         runtime/perl-520 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-520
<% end -%>

%description 520
<%= data['abstract'] %>
%endif

%if %{build522}
%package 522
IPS_package_name: library/perl-5/%{ips_cpan_name}-522
Summary:          <%= data['abstract'] %>
BuildRequires:    runtime/perl-522 = *
<% data[:build_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-522
<% end -%>
<% data[:runtime_requires].each do |req| -%>
BuildRequires:    library/perl-5/<%= req %>-522
<% end -%>
Requires:         runtime/perl-522 = *
Requires:         library/perl-5/%{ips_cpan_name}
<% data[:runtime_requires].each do |req| -%>
Requires:         library/perl-5/<%= req %>-522
<% end -%>

%description 522
<%= data['abstract'] %>
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

    echo ${perl_ver} | egrep '5\.(84|12)' > /dev/null
    if [ $? -eq 0 ]
    then
        make CC='cc -m32' LD='cc -m32'
        [ "x${test}" = 'xwithout_test' ] || make test CC='cc -m32' LD='cc -m32'
    else
        make CC='cc -m64' LD='cc -m64'
        [ "x${test}" = 'xwithout_test' ] || make test CC='cc -m64' LD='cc -m64'
    fi

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
    [ "x${test}" = 'xwithout_test' ] || ${bindir}/perl ./Build test
    ${bindir}/perl ./Build install --destdir $RPM_BUILD_ROOT
    ${bindir}/perl ./Build clean
}

modify_bin_dir() {
    perl_ver=$1
    if [ -d $RPM_BUILD_ROOT/usr/bin ]
    then
      [ -d $RPM_BUILD_ROOT/usr/perl5/${perl_ver} ] || mkdir -p $RPM_BUILD_ROOT/usr/perl5/${perl_ver}
      mv $RPM_BUILD_ROOT/usr/bin $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/bin
    fi
      
    if [ -d $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/bin ]
    then
        for i in $RPM_BUILD_ROOT/usr/perl5/${perl_ver}/bin/*
        do
            sed -i.bak -e "s/\/usr\/bin\/env ruby/\/usr\/perl5\/${perl-ver}\/bin\/ruby/" ${i}
            [ -f ${i}.bak] || rm -f ${i}.bak
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
        if [ %{include_executable} -eq 0 ]
        then
            rmdir $RPM_BUILD_ROOT/usr/perl5/${perl_ver}
        fi

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
build_for 5.8.4
%endif

%if %{build510}
build_for 5.10
%endif

%if %{build512}
build_for 5.12
%endif

%if %{build516}
build_for 5.16
%endif

%if %{build520}
build_for 5.20
%endif

%if %{build522}
build_for 5.22
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

%if %{build522}
%files 522
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/perl5/vendor_perl/5.22
%if %{include_executable}
/usr/perl5/5.22
%endif
%endif

%changelog
* <%= Time.now.strftime('%a %b %d %Y') %> - NAME <MAILADDR>
- initial commit
