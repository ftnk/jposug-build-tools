require 'spec_helper'
require 'tempfile'

specfile_dir = 'spec/fixtures/specfiles'
specfile = "#{specfile_dir}/SFEperl-lwp.spec"
macro_file_dir = 'spec/fixtures/pkgbuild'
macro_file = "#{macro_file_dir}/macros"

describe 'JPOSUG::ParseSpec' do
  jps = JPOSUG::ParseSpec.new(specfile, JPOSUG::ParseMacro.new(macro_file).macros)

  describe '#initialize' do
    describe '@specfile' do
      subject { jps.instance_variable_get('@specfile') }
      it { should be_a(String) }
      it { should eq specfile }
    end

    describe '@variables' do
      subject { jps.instance_variable_get('@variables') }
      it { should be_a(Hash) }

      describe '@varialbles["default"]["name"]' do
        subject { jps.instance_variable_get('@variables')['default']['name']}
        it { should eq 'SFEperl-libwww-perl' }
      end

      describe '@varialbles["default"]["ips_package_name"]' do
        subject { jps.instance_variable_get('@variables')['default']['ips_package_name']}
        it { should eq 'library/perl-5/lwp' }
      end
    end

    describe '@contexts' do
      subject { jps.instance_variable_get('@contexts') }
      it { should be_a(Array) }
    end

    describe '@defined_valiables' do
      subject { jps.instance_variable_get('@defined_variables') }
      it { should be_a(Hash) }
    end

    describe '@spec' do
      subject { jps.instance_variable_get('@spec') }
      it { should be_a(String) }
    end
  end

  # def normalize_value(value, context = nil)
  describe '#normalize_value' do
    context 'hello' do
      subject { jps.send(:normalize_value, 'hello') }
      it { should eq 'hello' }
    end

    context '%{name}' do
      subject { jps.send(:normalize_value, '%{name}') }
      it { should eq 'SFEperl-libwww-perl' }
    end

    context '%{name}:%{version}' do
      subject { jps.send(:normalize_value, '%{name}:%{version}') }
      it { should eq 'SFEperl-libwww-perl:6.13' }
    end

    context "%( if [ -x /usr/bin/perl ]; then echo '1'; else echo '0'; fi)" do
      subject { jps.send(:normalize_value, "%( if [ -x /usr/bin/perl ]; then echo '1'; else echo '0'; fi)") }
      it { should eq '1' }
    end

    # nested paren
    value = "%(egrep 'Oracle Solaris (11.[23]|12)' tmpfile > /dev/null ; if [ $? -eq 0 ]; then echo '1'; else echo '0'; fi)"
    context value do
      before :all do
        @tmpfile = Tempfile.new('rspec')
        @tmpfile.puts 'Oracle Solaris 11.3'
        @tmpfile.close
      end

      after :all do
        @tmpfile.unlink
      end

      subject { jps.send(:normalize_value, value.sub(/tmpfile/, @tmpfile.path)) }
      it { should eq '1' }
    end
  end

  # def parse_conditional(cond, last_if)
  describe '#parse_conditional' do
    v = jps.instance_variable_get(:@defined_variables)
    v['true'] = '1'
    v['false'] = '0'
    jps.instance_variable_set(:@defined_variables, v)

    describe 'return true' do
      context 'true, nil' do
        subject { jps.send(:parse_conditional, 'true', nil) }
        it { should eq true }
      end

      context 'true, true' do
        subject { jps.send(:parse_conditional, 'true', true) }
        it { should eq true }
      end
    end

    describe 'return false' do
      context 'false, nil' do
        subject { jps.send(:parse_conditional, 'false', nil) }
        it { should eq false }
      end

      context 'false, true' do
        subject { jps.send(:parse_conditional, 'false', true) }
        it { should eq false }
      end

      context 'false, false' do
        subject { jps.send(:parse_conditional, 'false', false) }
        it { should eq false }
      end

      context 'true, false' do
        subject { jps.send(:parse_conditional, 'true', false) }
        it { should eq false }
      end
    end
  end

  # describe '#parse_define' do
  #   describe '%define false $(echo \'0\')' do
  #     subject { jps.send(:parse_define, 'false', "%(echo '0')") }
  #     it { should eq '0' }
  #   end

  #   describe '%define true %(echo \'1\')' do
  #     subject { jps.send(:parse_define, 'true', "%(echo '1')") }
  #     it { should eq '1' }
  #   end

  #   name = 'build999'
  #   value = '%( if [ -x /usr/perl5/999/bin/perl ]; then echo \'1\'; else echo \'0\'; fi)'
  #   describe "%define #{name} #{value}" do
  #     subject { jps.send(:parse_define, name, value) }
  #     it { should eq '0' }
  #   end

  #   name2 = 'after_oracle_solaris_11_2'
  #   value2 = "%(egrep 'Oracle Solaris (11.[23]|12)' /etc/release > /dev/null ; if [ $? -eq 0 ]; then echo '1'; else echo '0'; fi)"
  #   describe "%define #{name2} #{value2}" do
  #     subject { jps.send(:parse_define, name2, value2) }
  #     it { should eq '1' }
  #   end
    
  # end

  # def query(q)
  describe '#query' do
    describe 'name' do
      subject { jps.query('name') }
      it { should eq ['SFEperl-libwww-perl'] }
    end
  end

  describe '#replace_variables' do
    context 'str = "%{name}", variables = ["name"]' do
      subject { jps.send(:replace_variables, '%{name}', ['name']) }
      it { should eq 'SFEperl-libwww-perl' }
    end
  end

  describe '#replace_commands' do
    context 'str = \'%(echo \'1\')\', commands = [\'echo \'1\'\']' do
      subject { jps.send(:replace_commands, '%(echo \'1\')', ['echo \'1\'']) }
      it { should eq '1' }
    end

    str = "%( if [ -x /usr/perl5/999/bin/perl ]; then echo \'1\'; else echo \'0\'; fi)"
    context "str = #{str}" do
      subject { jps.send(:replace_commands, str, [str.gsub(/(?:^%\(|\)$)/, '')]) }
      it { should eq '0' }
    end

    str2 = "%(egrep 'Oracle Solaris (11.[23]|12)' /etc/release > /dev/null ; if [ $? -eq 0 ]; then echo '1'; else echo '0'; fi)"
    context "str = #{str2}" do
      subject { jps.send(:replace_commands, str2, [str2.gsub(/(?:^%\(|\)$)/, '')]) }
      it { should eq '1' }
    end

    str3 = "%(%{__perl} -MConfig -e 'print $Config{vendorarch}')"
    context "str = #{str3}" do
      subject { jps.send(:replace_commands, str3, [str3.gsub(/(?:^%\(|\)$)/, '')]) }
      it { should eq '/usr/perl5/vendor_perl/5.12/i86pc-solaris-64int' }
    end
  end
end
