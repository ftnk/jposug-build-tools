require 'spec_helper'

macro_file_dir = 'spec/fixtures/pkgbuild'
macro_file = "#{macro_file_dir}/macros"

describe 'JPOSUG::ParseMacro' do
  jpm = JPOSUG::ParseMacro.new(macro_file)

  describe '#macros' do
    subject { jpm.macros }
    it { should include('_vendor' => 'sun') }
    it { should include('_host_vendor' => 'sun') }
    it { should include('_build_vendor' => 'sun') }
  end
end
