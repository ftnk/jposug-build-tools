# coding: utf-8
require 'json'

module JPOSUG
  #
  class Build
    attr_reader :ipsname2name, :ipsname2specfile, :name2specfile, :buildrequires

    def initialize()
      @specfiles = {}
      @ipsname2name = {}
      @ipsname2specfile = {}
      @spec2ips = {}
      @name2specfile = {}
      @name2ipsname = {}
      @buildrequires = {}
      @requires = {}
      @pnmacros = {}
      @macros = JPOSUG::ParseMacro.new.macros

      pnmacros
    end

    def read_buildlist(buildlist)
      fail "file not found. #{buildlist}" unless File.exist?(buildlist)

      list = File.open(buildlist).read.force_encoding('UTF-8')

      list.split(/\n/).each do |line|
        next if /\A(#.*|\s*)\z/ =~ line
        read_specfile(line)
      end
    end

    def spec2ipsname_list
      res = []
      @spec2ips.each do |spec,ips|
        ips.each do |v|
          res << "#{spec}:#{v}"
        end
      end
      return res
    end

    def spec2ipsname_json
      JSON.dump(@spec2ips)
    end

    def name2specfile_json
      JSON.dump(@name2specfile)
    end

    def target_mak
      @buildrequires.each do |specfile, req|
        prebuild, preinstall = parse_requires(req)
        output_dependency_for_proto(specfile, prebuild)
        output_preinstall(preinstall)
      end
    end

    def pnmacros
      data = File.open('./include/packagenames.define-133.inc').read.split(/\n/)
      data += File.open('./include/packagenames.define-134.inc').read.split(/\n/)

      data.each do |line|
        if /\A%define\s+(.+)\s+(.+)\z/ =~ line
          @pnmacros[$1] = $2
        end
      end
    end

    def read_specfile(specfile)
      fail "file not found. #{specfile}" unless File.exist?(specfile)

      spec = JPOSUG::ParseSpec.new(specfile, @macros)
      @specfiles[specfile] = spec
      @buildrequires[specfile] = spec.query('buildrequires').uniq
      @name2specfile[spec.variables['default']['name']]  = specfile
      map_package(specfile, spec)
    end

    def map_package(specfile, spec)
      spec.query('ips_package_name').each do |ips|
        map_spec2ips(specfile, ips)
        map_name2ipsname(spec, ips)
        map_ipsname2name(spec, ips)
        map_ipsname2specfile(specfile, ips)
      end
    end

    def map_spec2ips(specfile, ips)
      @spec2ips[specfile] = [] if @spec2ips[specfile].nil?
      @spec2ips[specfile] << ips
    end

    def map_name2ipsname(spec, ips)
      name = spec.variables['default']['name']
      @name2ipsname[name] = [] if @name2ipsname[name].nil?
      @name2ipsname[name] << ips
    end

    def map_ipsname2name(spec, ips)
      # 1 対 1 対応なので、配列を用意する必要はない。
      # nil または、設定済みの値と設定したい値が同じでなければ
      # 例外をあげるなどの処理が必要。
      # @ipsname2name[ips] = [] if @ipsname2name[ips].nil?
      @ipsname2name[ips] = spec.variables['default']['name']
    end

    def map_ipsname2specfile(specfile, ips)
      # 1 対 1 対応なので、配列を用意する必要はない。
      # nil または、設定済みの値と設定したい値が同じでなければ
      # 例外をあげるなどの処理が必要。
      # @ipsname2specfile[ips] = [] if @ipsname2specfile[ips].nil?
      @ipsname2specfile[ips] = specfile
    end

    def parse_requires(req)
      preinstall = []
      prebuild = []

      req.uniq.each do |b|
        if @ipsname2name[b].is_a?(String)
          prebuild << "#{@name2specfile[@ipsname2name[b]].sub(/\.spec$/, '')}.proto"
        elsif /%{?(pnm_(build)?requires_.+)}?/ =~ b
          preinstall << @pnmacros[$1]
        else
          preinstall << b
        end
      end
      return prebuild, preinstall
    end

    def output_dependency_for_proto(specfile, prebuild)
      proto = specfile.sub(/\.spec$/, '.proto')
      puts "#{proto} : #{specfile} #{prebuild.sort.uniq.join(' ')}"
    end

    def output_preinstall(preinstall)
      preinstall.uniq.each do |pre|
        next if pre.nil?
        # BuildRequire は 1 行 1 パッケージという前提で
        # バージョン指定を削除
        pre = pre.strip.split(/\s+/)[0]
        puts format_preinstall(pre)
      end
    end

    def format_preinstall(pre)
      fail 'pre should be a String.' unless pre.is_a?(String) || pre.size > 0
      if /\ASFE.+/ =~ pre
        ips = @name2ipsname[pre]
        # ips が nil になるということは、
        # 依存するパッケージが build list に入っていないか
        # parse に失敗している。
        STDERR.puts "ips package for #{pre} not found." if ips.nil?

        ips = ips.flatten.join(' ') if ips.is_a?(Array)
        pre = ips
      end
      "PERINSTALL+=#{pre}"
    end
  end
end
