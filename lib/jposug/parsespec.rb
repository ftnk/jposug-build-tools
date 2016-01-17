# -*- coding: utf-8 -*-

module JPOSUG
  #
  class ParseSpec
    VARIABLE_REG = /Name|IPS_package_name|Version|License|Group|URL|Source\d+|Patch\d+|BuildRoot|BuildRequires|Requires/i
    PKGBUILD_MACROS_REG = /_tmppath|pnm_.+/

    attr_reader :variables

    def initialize(specfile, macro = nil)
      @specfile = specfile
      @defined_variables = macro ? macro : {}
      @variables = {}
      @contexts = []
      @stack_if = []

      initialize_context('default')

      @spec = read_specfile
      parse_spec
    end

    def read_specfile
      if File.exist?(@specfile)
        return File.open(@specfile).read.force_encoding('UTF-8')
      else
        fail "file not found. #{@specfile}"
      end
    end

    def parse_spec
      @spec.split(/\n/).each do |line|
        # %if と %endif の対を確認するため、%if と %endif は無視しない
        next if line !~ /^%(end)?if/ && @stack_if[-1] == false
        next if line =~ /^(#|[^A-Za-z%])/
        parse_line(line)
      end
    end

    def query(q)
      res = []
      if @defined_variables[q].is_a?(String)
        res << @defined_variables[q]
      end

      @contexts.uniq.each do |context|
        unless @variables[context].nil? || @variables[context].empty?
          if @variables[context][q].is_a?(String)
            res << @variables[context][q]
          elsif @variables[context][q].is_a?(Array)
            res += @variables[context][q]
          end
        end
      end
      res
    end

    private

    def normalize_variable(name, value)
      value = value.chomp.strip
      value = normalize_value(value) if value =~ /%{.+}/
      return name.downcase, value
    end

    def validate_variable(name, value)
      if @variables[@current_context][name.downcase] && name !~ /Requires/i
        STDERR.puts "@variable[#{@current_context}][#{name.downcase}] is already defined!"
        STDERR.puts "specfile: #{@specfile}"
        STDERR.puts "current: #{value}"
        STDERR.puts "defined: #{@variable[@current_context][name.downcase]}"
        exit 1
      end
    end

    def parse_conditional(cond, last_if)
      if @defined_variables[cond].nil? || @defined_variables[cond] == '0'
        false
      else
        # 条件の評価と、false 時の読み飛ばしを兼ねてしまっているので、あとで整理する
        if last_if == false
          false
        else
          true
        end
      end
    end

    def initialize_context(context)
      @current_context = context
      fail "#{context} is already decleard in #{@specfile}" if @contexts.include?(@current_context)

      @contexts << @current_context
      @variables[@current_context] = {}
      @variables[@current_context]['requires'] = []
      @variables[@current_context]['buildrequires'] = []
    end

    # 何かの値の中で使われる変数は、たいてい、@defined_variables か @variables['default'] の中にあるはず。
    # @variable[（default 以外）] は、perl なら、'%package 512' などの部分になるので、
    # そこの変数が使われることはなさそう。
    def replace_variables(str, variables, context = nil)
      variables.each do |v|
        next if v.nil?
        if @defined_variables[v.downcase].is_a?(String)
          str.sub!(/(?:%{#{v}}|%#{v})/, @defined_variables[v.downcase])
        elsif @variables['default'][v.downcase].is_a?(String)
          str.sub!(/(?:%{#{v}}|%#{v})/, @variables['default'][v.downcase])
        elsif !context.nil? && @variables[context][v.downcase].is_a?(String)
          str.sub!(/(?:%{#{v}}|%#{v})/, @variables[context][v.downcase])
        else
          # spec file などで定義されていない macro（_tmppath など）があるので、
          # それらもちゃんと読み込むか、無視するかする必要がある

          # context = 'nil' if context.nil?
          # fail "replacing varialbe failed. str=#{str}, variable=#{v}, context=#{context}"
        end
      end
      str
    end

    def replace_commands(str, commands)
      commands.each do |cmd|
        original_cmd = cmd.dup
        cmd = normalize_value(cmd) if cmd =~ /%{.+}/
        str.sub!(/%\(\s*#{Regexp.escape(original_cmd)}\s*\)/, `#{cmd}`.chomp)
      end
      str
    end

    def normalize_value(value, context = nil)
      variables = value.scan(/%{(.+?)}/).flatten
      commands = value.scan(/%(?<paren>\((?:[^()]|\g<paren>)*\))/).flatten
      return value if variables.empty? && commands.empty?

      commands = commands.map { |i| i.strip.gsub(/(^\(|\)$)/, '') }

      value = replace_variables(value, variables)
      value = replace_commands(value, commands)
      value
    end

    def store_variable(name, value)
      validate_variable(name, value)
      if @variables[@current_context][name].is_a? Array
        @variables[@current_context][name] << value
      else
        @variables[@current_context][name] = value
      end
    end

    def parse_line(line)
      case line
      when /\A%endif\z/
        @stack_if.pop
      when /\A%define\s+(\S+)\s+(.+)\z/
        name, value = Regexp.last_match[1..2]
        @defined_variables[name.downcase] = normalize_value(value)
      when /\A(#{VARIABLE_REG}):\s+(.+)(\s+[\d.]+)?\z/
        n, v = normalize_variable(Regexp.last_match(1), Regexp.last_match(2))
        store_variable(n, v)
      when /\A%package\s+(.+)\z/
        initialize_context(Regexp.last_match(1))
      when /\A%if %{(.+)}\z/
        @stack_if << parse_conditional(Regexp.last_match(1), @stack_if[-1])
      end
    end
  end
end
