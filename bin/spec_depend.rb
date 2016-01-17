#!/usr/bin/ruby
# -*- coding: utf-8 -*-
=begin

= spec_depend.rb

Ruby version of spec_depend.pl.

== usage

  spec_depend.rb build.list

=end

require_relative '../lib/parsespec.rb'

def usage
  puts 'usage: spec_depend2.rb build.list'
end

if ARGV.size != 1
  usage
  exit 1
end

buildlist = ARGV[0]

unless File.exist? buildlist
  STDERR.puts "build list not found. #{BUILDLIST}"
  exit 1
end

build = JPOSUG::Build.new
build.read_buildlist(buildlist)

File.open('spec2ipsname.list', 'w').puts build.spec2ipsname_list
File.open('spec2ipsname.json', 'w').puts build.spec2ipsname_json
File.open('name2specfile.json', 'w').puts build.name2specfile_json

build.target_mak
