require 'spec_helper'

specfile_dir = 'spec/fixtures/specfiles'
build_list = 'build.list'
build_list_with_error = 'build.list.error'
build_list_not_exist = 'build.list.not_exist'

describe 'JPOSUG::Build' do
  describe '#initialize' do
    before :each do
      @pwd = Dir.pwd
      Dir.chdir(specfile_dir)
    end

    after :each do
      Dir.chdir(@pwd)
    end

    it do
      expect { JPOSUG::Build.new  }.to_not raise_error
    end
  end

  describe '#read_buildlist' do
    pwd = Dir.pwd
    Dir.chdir(specfile_dir)
    jb = JPOSUG::Build.new
    Dir.chdir(pwd)

    before :each do
      @pwd = Dir.pwd
      Dir.chdir(specfile_dir)
    end

    after :each do
      Dir.chdir(@pwd)
    end

    context "#{build_list_not_exist}" do
      it do
        expect { jb.read_buildlist(build_list_not_exist) }.
          to raise_error(RuntimeError, "file not found. #{build_list_not_exist}")
      end
    end

    context "#{build_list_with_error}" do
      it do
        expect { jb.read_buildlist(build_list_with_error) }.
          to raise_error(RuntimeError, 'file not found. hoge.spec')
      end
    end

    context "#{build_list}" do
      it { expect { jb.read_buildlist(build_list) }.to_not raise_error }

      describe 'variables' do
        pwd = Dir.pwd
        Dir.chdir(specfile_dir)
        jb.read_buildlist(build_list)

        describe 'buildrequires' do
          describe 'includes "SFEperl-lwp.spec"' do
            subject { jb.buildrequires }
            it { should include 'SFEperl-lwp.spec' }
          end

          describe '[\'SFEperl-lwp.spec\']' do
            subject { jb.buildrequires['SFEperl-lwp.spec'] }
            it { should include 'runtime/perl-512 = *' }
          end
        end
        Dir.chdir(pwd)
      end
    end
  end

# read_buildlist(buildlist)
# spec2ipsname_list
# spec2ipsname_json
# name2specfile_json
# target_mak
# pnmacros
end
