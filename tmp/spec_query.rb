#!/usr/bin/ruby

require_relative '../lib/jposug.rb'

def usage()
  puts "usage: parse_spec.rb spec_file query"
end

if ARGV.size != 2
  usage
  exit 1
end

spec_file, query = ARGV

unless File.exist?(spec_file)
  puts "file not found. #{spec_file}"
  usage
  exit 1
end

spec = JPOSUG::ParseSpec.new(spec_file)
puts spec.query(query)
