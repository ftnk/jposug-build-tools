#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require_relative '../lib/jposug.rb'

# SPECTOOL= '/usr/bin/spectool'
BUILDLIST = "build.list.#{`uname -v`.chomp}"

unless File.exist? BUILDLIST
  STDERR.puts "build list not found. #{BUILDLIST}"
  exit 1
end

specfiles = File.open(BUILDLIST).read
macros = JPOSUG::ParseMacro.new.macros

specfiles.split(/\n/).each do |specfile|
  next if /^\s*(#.*)?$/ =~ specfile
  unless File.exist? specfile
    STDERR.puts "file not found. #{specfile}"
    exit 1
  end

  spec = JPOSUG::ParseSpec.new(specfile, macros)
  spec.variables.each do |k, v|
    if v['ips_package_name'].is_a?(Array)
      v['ips_package_name'].uniq.each do |ips|
        puts "#{specfile}:#{ips}"
      end
    elsif v['ips_package_name'].is_a?(String)
      puts "#{specfile}:#{v['ips_package_name']}"
    else
      STDERR.puts "Unknown variable in #{specfile}"
      STDERR.puts "- #{k}: #{v}"
    end
  end
end
