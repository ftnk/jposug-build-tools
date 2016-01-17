#!/usr/bin/ruby
require 'pp'
require 'json'
require_relative '../lib/jposug.rb'

protofile = ARGV.shift

if ENV['PKGBUILD_IPS_REPO'].nil?
  PKGBUILD_IPS_REPO = 'localhost'
else
  PKGBUILD_IPS_REPO = ENV['PKGBUILD_IPS_REPO']
end

name = protofile.sub(/\.proto$/, '')
specname = "#{name}.spec"
infoname =" #{name}.info"

s2i = JSON.load(File.read('spec2ipsname.json'))
n2s = JSON.load(File.read('name2specfile.json'))

unless File.exist?(specname)
  specname = n2s[name]
end

puts specname
b = JPOSUG::ParseSpec.new(specname)
name = b.variables['default']['name']

packages = s2i[n2s[name]].map{ |i| "pkg://#{PKGBUILD_IPS_REPO}/#{i}" }
command = "sudo pkg install -v --no-backup-be #{packages.join(' ')}"
puts command
`#{command}`

command = "sudo pkg info #{packages.join(' ')} > #{infoname}"
`#{command}`

