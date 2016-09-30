require 'spec_helper'

rvm_default_ruby = 'ruby-2.2'
rvm_init_script = File.join('', 'home', 'vagrant', '.rvm', 'scripts', 'rvm' )

describe '## RVM and Ruby' do

    describe file( rvm_init_script ) do
      it { should be_file }
      it { should be_owned_by 'vagrant' }
      it { should be_grouped_into 'vagrant' }
      it { should be_mode 775 }
      its(:content) { should match /RVM/ }
    end

    describe command("rvm version") do
      its(:stdout) { should match /^rvm\s+[\d.-_]+/ }
    end

    describe command("rvm list strings") do
      its(:stdout) { should contain( rvm_default_ruby ) }
    end

    describe command("ruby --version") do
      its(:stdout) { should match rvm_default_ruby.split('-')[-1].to_s }
    end

end