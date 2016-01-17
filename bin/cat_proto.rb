#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require_relative '../lib/jposug.rb'
require 'pp'

PROTO_DIR="#{ENV['HOME']}/packages/PKGMAPS/proto"

if ARGV.size != 1
  exit 1
end

specfile = ARGV[0]

unless File.exist? specfile
  STDERR.puts "file not found. #{specfile}"
  exit 1
end

spec = JPOSUG::ParseSpec.new(specfile)
name = spec.variables['default']['name']
proto_file = "#{PROTO_DIR}/#{name}.proto"

if File.exist? proto_file
  puts File.open(proto_file).read
else
  STDERR.puts "file not found. #{proto_file}"
end
