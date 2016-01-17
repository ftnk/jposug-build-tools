# -*- coding: utf-8 -*-

module JPOSUG
  #
  class ParseMacro
    attr_reader :macro_file, :macros

    def initialize(macro_file = nil)
      @macro_file = macro_file ? macro_file : search_macro_file
      @macros = {}
      parse_macro
    end

    private

    def search_macro_file
      macro_file = Dir.glob('/usr/lib/pkgbuild*/macros').last
      fail "file '/usr/lib/pkgbuild*/macros' not found." if macro_file.nil?
      macro_file
    end

    def parse_macro(macro_file = @macro_file)
      hash = {}
      File.open(macro_file).read.split(/\n/).each do |line|
        next if line !~ /^%_/
        next if line =~ /(?:^%nil|%{nil}$)/

        line.match(/^%(\S+)\s+(.+)$/)
        hash[Regexp.last_match(1)] = Regexp.last_match(2)
      end
      store_macro(hash)
    end

    def store_macro(hash)
      3.times do
        hash.each do |k, v|
          @macros[k] = normalize_value(v)
        end
      end
    end

    def normalize_value(value)
      macros = value.scan(/%{(.+?)}/).flatten
      return value if macros.empty?

      replace_macros(value, macros)
    end

    def replace_macros(value, macros)
      macros.each do |m|
        next if m.nil?
        value.sub!(/(?:%{#{m}}|%#{m})/, @macros[m]) if @macros[m].is_a?(String)
      end
      value
    end
  end
end

