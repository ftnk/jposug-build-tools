#!/usr/bin/ruby
# -*- coding: utf-8 -*-
=begin
make_pypi_spec.rb

pypi の API を使って Python 用の spec file を生成する。

usage: make_pypi_spec.rb python_package

=end

require 'open-uri'
require 'json'
require 'erb'
require 'pp'

def usage()
  puts "usage: #{File.basename($0)} gemname"
end

unless ARGV.size == 1
  usage
  exit 1
end

package_name = ARGV.shift

specfile = "SFEpython-#{package_name.downcase}.spec"
if File.exist?(specfile)
  STDERR.puts "file alerady exists. #{specfile}"
  exit 1
end

puts "get python package information: #{package_name}"
json = open("https://pypi.python.org/pypi/#{package_name.downcase}/json").read
data = JSON.load(json)['info']

puts "output: #{specfile}"
File.open(specfile, 'w').puts ERB.new(DATA.read, nil, '-').result(binding)

__END__
%include Solaris.inc
%include packagenamemacros.inc
%include default-depend.inc

%define build26 %( if [ -x /usr/bin/python2.6 ]; then echo '1'; else echo '0'; fi)
%define build27 %( if [ -x /usr/bin/python2.7 ]; then echo '1'; else echo '0'; fi)
%define build34 %( if [ -x /usr/bin/python3.4 ]; then echo '1'; else echo '0'; fi)
%define build35 %( if [ -x /usr/bin/python3.5 ]; then echo '1'; else echo '0'; fi)

%define tarball_index <%= data['name'][0] %>
%define tarball_name <%= data['name'] %>
%define tarball_version <%= data['version'] %>
%define include_executable 0

Name:                    SFEpython-<%= data['name'].downcase %>
IPS_package_name:        library/python/<%= data['name'].downcase %>
Summary:                 <%= data['summary'] %>
<% url = data['home_page'].size > 0 ? data['home_page'] : data['package_url'] -%>
URL:                     <%= url %>
Version:                 %{tarball_version}
License:                 <%= data['license'] %>
Source:                  http://pypi.python.org/packages/source/%{tarball_index}/%{tarball_name}/%{tarball_name}-%{tarball_version}.tar.gz
BuildRoot:               %{_tmppath}/%{name}-%{version}-build

%description
<%= data['summary'] %>

%if %{build26}
%package 26
IPS_package_name: library/python/<%= data['name'].downcase %>-26
Summary:          <%= data['summary'] %>
BuildRequires:    runtime/python-26
Requires:         runtime/python-26
Requires:         library/python/<%= data['name'].downcase %>

%description 26
<%= data['summary'] %>
%endif

%if %{build27}
%package 27
IPS_package_name: library/python/<%= data['name'].downcase %>-27
Summary:          <%= data['summary'] %>
BuildRequires:    runtime/python-27
Requires:         runtime/python-27
Requires:         library/python/<%= data['name'].downcase %>

%description 27
<%= data['summary'] %>
%endif

%if %{build34}
%package 34
IPS_package_name: library/python/<%= data['name'].downcase %>-34
Summary:          <%= data['summary'] %>
BuildRequires:    runtime/python-34
Requires:         runtime/python-34
Requires:         library/python/<%= data['name'].downcase %>

%description 34
<%= data['summary'] %>
%endif

%if %{build35}
%package 35
IPS_package_name: library/python/<%= data['name'].downcase %>-35
Summary:          <%= data['summary'] %>
BuildRequires:    runtime/python-35
Requires:         runtime/python-35
Requires:         library/python/<%= data['name'].downcase %>

%description 35
<%= data['summary'] %>
%endif


%prep
%setup -q -n %{tarball_name}-%{tarball_version}
if [ -d $RPM_BUILD_ROOT ]
then
    rm -rf $RPM_BUILD_ROOT
fi

%build
build_for () {
    python_version=$1

    /usr/bin/python${python_version} setup.py build
    /usr/bin/python${python_version} setup.py install \
        --skip-build \
        --root=$RPM_BUILD_ROOT

    if [ -d $RPM_BUILD_ROOT/usr/bin ]
    then
        for i in $(ls $RPM_BUILD_ROOT/usr/bin/*|egrep -v '[0-9]$')
        do
            mv ${i} ${i}-${python_version}
        done
    fi
}

%if %{build26}
build_for 2.6
%endif

%if %{build27}
build_for 2.7
%endif

%if %{build34}
build_for 3.4
%endif

%if %{build35}
build_for 3.5
%endif

%install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr (-, root, bin)
# %doc 

%if %{build26}
%files 26
%defattr (-, root, bin)
%dir %attr (0755, root, sys) /usr
%dir %attr (0755, root, bin) %{_libdir}
%dir %attr (0755, root, bin) %{_libdir}/python2.6
%{_libdir}/python2.6/site-packages
%if %{include_executable}
/usr/bin/*2.6
%endif
%endif

%if %{build27}
%files 27
%defattr (-, root, bin)
%dir %attr (0755, root, sys) /usr
%dir %attr (0755, root, bin) %{_libdir}
%dir %attr (0755, root, bin) %{_libdir}/python2.7
%{_libdir}/python2.7/site-packages
%if %{include_executable}
/usr/bin/*2.7
%endif
%endif

%if %{build34}
%files 34
%defattr (-, root, bin)
%dir %attr (0755, root, sys) /usr
%dir %attr (0755, root, bin) %{_libdir}
%dir %attr (0755, root, bin) %{_libdir}/python3.4
%{_libdir}/python3.4/site-packages
%if %{include_executable}
/usr/bin/*3.4
%endif
%endif

%if %{build35}
%files 35
%defattr (-, root, bin)
%dir %attr (0755, root, sys) /usr
%dir %attr (0755, root, bin) %{_libdir}
%dir %attr (0755, root, bin) %{_libdir}/python3.5
%{_libdir}/python3.5/site-packages
%if %{include_executable}
/usr/bin/*3.5
%endif
%endif

%changelog
* <%= Time.now.strftime('%a %b %d %Y') %> - NAME <MAILADDR>
- initial commit
