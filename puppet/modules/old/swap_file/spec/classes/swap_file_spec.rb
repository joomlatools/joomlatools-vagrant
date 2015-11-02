require 'spec_helper'

describe 'swap_file' do

  shared_examples "compiles and contains classes" do
    it { should compile.with_all_deps }
    it { should contain_class('Swap_file::Params') }
    it { should contain_class('Swap_file') }
  end

  shared_examples "with default parameters" do |osfamily|
    let(:facts) {{
      :osfamily => osfamily, :memorysize => '1 GB',
    }}
    it { should compile.with_all_deps }
    it { should contain_file('/mnt/swap.1') }

    it { should contain_swap_file__files('/mnt/swap.1') }
    it {
        should contain_exec('Create swap file /mnt/swap.1').
          with_command('/bin/dd if=/dev/zero of=/mnt/swap.1 bs=1M count=1073')
        }
    it { should contain_exec('Attach swap file /mnt/swap.1') }
    it { should contain_mount('/mnt/swap.1').with_ensure('present') }
  end

  shared_examples "with swapfile and size parameters" do |osfamily|
    let(:params) {{ :swapfile => '/foo/bar', :swapfilesize => '2 GB' }}
    let(:facts) {{
      :osfamily => osfamily, :memorysize => '1 GB',
    }}
    it { should compile.with_all_deps }
    it { should contain_file('/foo/bar') }

    it { should contain_swap_file__files('/foo/bar') }
    it {
        should contain_exec('Create swap file /foo/bar').
          with_command('/bin/dd if=/dev/zero of=/foo/bar bs=1M count=2147')
        }
    it { should contain_exec('Attach swap file /foo/bar') }
    it { should contain_mount('/foo/bar').with_ensure('present') }
  end

  shared_examples "can specify no mount" do |osfamily|
    let(:params) {{ :add_mount => false, }}
    let(:facts) {{
      :osfamily => osfamily, :memorysize => '1 GB',
    }}
    it { should compile.with_all_deps }
    it { should contain_file('/foo/bar') }

    it { should contain_swap_file__files('/foo/bar') }
    it {
        should contain_exec('Create swap file /foo/bar').
          with_command('/bin/dd if=/dev/zero of=/foo/bar bs=1M count=1073')
        }
    it { should contain_exec('Attach swap file /foo/bar') }
    it { should_not contain_mount('/foo/bar').with_ensure('present') }
  end

  context 'officially support operating system' do
    describe 'Debian' do
      it_behaves_like "compiles and contains classes"

      it_behaves_like "with default parameters", :osfamily => 'Debian'

      it_behaves_like "with swapfile and size parameters", :osfamily => 'Debian'
    end

    describe 'RedHat' do
      it_behaves_like "compiles and contains classes"

      it_behaves_like "with default parameters", :osfamily => 'RedHat'

      it_behaves_like "with swapfile and size parameters", :osfamily => 'RedHat'
    end
  end

  context 'not officially support operating system' do
    describe 'Solaris' do
      it_behaves_like "compiles and contains classes"

      it_behaves_like "with default parameters", :osfamily => 'Solaris'

      it_behaves_like "with swapfile and size parameters", :osfamily => 'Solaris'
    end
  end

  context 'windows operating system' do
    describe 'swap_file class without any parameters on Windows' do
      let(:facts) {{
        :osfamily        => 'windows',
        :operatingsystem => 'windows',
      }}

      it { expect { should contain_class('swap_file') }.to raise_error(/Swap files dont work on windows/) }
    end
  end

  context 'FreeBSD operating system' do
    describe 'swap_file class without any parameters on FreeBSD' do
      let(:facts) {{
        :osfamily        => 'FreeBSD',
        :operatingsystem => 'FreeBSD',
      }}

      it { expect { should contain_class('swap_file') }.to raise_error(/FreeBSD is not yet supported/) }
    end
  end

end
