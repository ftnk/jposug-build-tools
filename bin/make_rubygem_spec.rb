#!/usr/bin/ruby
# -*- coding: utf-8 -*-
=begin
make_rubygem_spec.rb

rubygem 用の spec file を生成する。

usage: make_rubygem_spec.rb gemname

=end

require 'open-uri'
require 'json'
require 'erb'

API_ENDPOINT = 'https://rubygems.org/api/v1/gems'

TARGET_VERSIONS=%w(21 22 23 24)

def usage()
  puts "usage: #{File.basename($0)} gemname"
end

unless ARGV.size == 1
  usage
  exit 1
end

gemname = ARGV.shift

specfile = "SFEruby-#{gemname}.spec"
if File.exist?(specfile)
  STDERR.puts "file alerady exists. #{specfile}"
  exit 1
end

puts "get gem information: #{gemname}"
json = open("#{API_ENDPOINT}/#{gemname}").read
data = JSON.load(json)

puts "output: #{specfile}"
File.open(specfile, 'w').puts ERB.new(DATA.read, nil, '-').result(binding)

__END__
%include Solaris.inc
%include default-depend.inc

<% TARGET_VERSIONS.each do |ver| -%>
%define build<%= ver %> %( if [ -x /usr/ruby/<%= ver.split('').join('.') %>/bin/ruby ]; then echo '1'; else echo '0'; fi)
<% end -%>
%define generate_executable 0
%define keep_dependency 0

%define gemname <%= data['name'] %>
%define sfe_gemname <%= data['name'].gsub(/_/, '-') %>

Summary:          <%= data['info'] %>
Name:             SFEruby-%{sfe_gemname}
IPS_package_name: library/ruby/%{gemname}
Version:          <%= data['version'] %>
License:          <%= data['licenses'].join(', ') unless data['licenses'].nil? %>
<% url = data['homepage_uri'].length > 0 ? data['homepage_uri'] : data['project_uri'] -%>
URL:              <%= url %>
Source0:          http://rubygems.org/downloads/%{gemname}-%{version}.gem
BuildRoot:        %{_tmppath}/%{name}-%{version}-build

%description
<%= data['info'] %>

<% TARGET_VERSIONS.each do |ver| -%>
%if %{build<%= ver %>}
<% if %w(21 22 23).include?(ver) -%>
%if %{keep_dependency}
%package <%= ver %>-old
IPS_package_name: library/ruby-<%= ver %>/%{gemname}
Summary:          <%= data['info'] %>
BuildRequires:    runtime/ruby-<%= ver %> = *
Requires:         runtime/ruby-<%= ver %> = *
Requires:         library/ruby/%{gemname}-<%= ver %>

%description <%= ver %>-old
<%= data['info'] %>
%endif
<% end -%>

%package <%= ver %>
IPS_package_name: library/ruby/%{gemname}-<%= ver %>
Summary:          <%= data['info'] %>
BuildRequires:    runtime/ruby-<%= ver %> = *
Requires:         runtime/ruby-<%= ver %> = *
<% data['dependencies']['runtime'].each do |req| -%>
<% next if req['name'].match(/^(rake|rdoc)$/) -%>
# <%= req['name'] %> <%= req['requirements'] %>
Requires:         library/ruby/<%= req['name'] %>-<%= ver %>
<% end -%>
Requires:         library/ruby/%{gemname}

%description <%= ver %>
<%= data['info'] %>
%endif

<% end -%>

%prep
%setup -q -c -T

%build
build_for() {
    ruby_ver=$1
    bindir="/usr/ruby/${ruby_ver}/bin"
    gemdir="$(${bindir}/ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)"
    geminstdir="${gemdir}/gems/%{gemname}-%{version}"

    ${bindir}/gem install --local \
        --no-env-shebang \
        --install-dir .${gemdir} \
        --bindir .${bindir} \
        --no-ri \
        --no-rdoc \
        -V \
        --force %{SOURCE0}
}

<% TARGET_VERSIONS.each do |ver| -%>
%if %{build<%= ver %>}
# ruby-<%= ver %>
build_for <%= ver.split('').join('.') %>
%endif
<% end -%>

%install
rm -rf %{buildroot}

%if %{generate_executable}
mkdir -p %{buildroot}/%{_bindir}
%endif

install_for() {
    ruby_ver=$1
    bindir="/usr/ruby/${ruby_ver}/bin"
    gemdir="$(${bindir}/ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)"
    geminstdir="${gemdir}/gems/%{gemname}-%{version}"

    mkdir -p %{buildroot}/usr/ruby/${ruby_ver}
    cp -a ./usr/ruby/${ruby_ver}/* \
        %{buildroot}/usr/ruby/${ruby_ver}/

    for dir in %{buildroot}${geminstdir}/bin %{buildroot}%{_bindir}
    do
	if [ -d ${dir} ]
	then
	    pushd ${dir}
	    for i in ./*
	    do
		if [ -f ${i} ]
		then
		    mv ${i} ${i}.bak
		    sed -e "s!^\#\!/usr/bin/env ruby\$!\#\!/usr/ruby/${ruby_ver}/bin/ruby!" \
			-e "s!^\#\!/usr/bin/ruby\$!\#\!/usr/ruby/${ruby_ver}/bin/ruby!" \
			-e "s!^\#\!ruby\$!\#\!/usr/ruby/${ruby_ver}/bin/ruby!" \
			${i}.bak > ${i}
		    rm ${i}.bak
		fi
	    done
	    popd
	fi
    done
   
%if %{generate_executable}
    pushd %{buildroot}%{_bindir}
    for i in $(ls ../ruby/${ruby_ver}/bin/*)
    do
	[ -f ${i} ] && ln -s ${i} $(basename ${i})$(echo ${ruby_ver}|sed -e 's/\.//')
    done
    popd
%endif

}

<% TARGET_VERSIONS.each do |ver| -%>
%if %{build<%= ver %>}
# ruby-<%= ver %>
install_for <%= ver.split('').join('.') %>
%endif
<% end -%>

%clean
rm -rf %{buildroot}

%files
%defattr(0755,root,bin,-)

<% TARGET_VERSIONS.each do |ver| -%>
%if %{build<%= ver %>}
%files <%= ver %>
%defattr(0755,root,bin,-)
%dir %attr (0755, root, sys) /usr
/usr/ruby/<%= ver.split('').join('.') %>
%if %{generate_executable}
%dir %attr (0755, root, bin) /usr/bin
%attr (0755, root, bin) /usr/bin/*<%= ver %>
%endif
%endif
<% end -%>

%changelog
* <%= Time.now.strftime('%a %b %d %Y') %> - NAME <MAILADDR>
- initial commit
