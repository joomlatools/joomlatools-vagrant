require 'spec_helper'

describe '## Apache' do
    describe package('apache2'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('apache2'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8080) do
      it { should be_listening }
    end

    describe file('/etc/apache2/conf-available/fqdn.conf') do
      it { should exist }
      its(:content) { should match /ServerName joomlatools/ }
    end

    describe file('/etc/apache2/apache2.conf') do
      it { should exist }
      its(:content) { should match /SetEnv JOOMLATOOLS_BOX \d\.\d\.\d/ }
    end

    describe command('a2dissite 000-default') do
      its(:stdout) { should match /Site 000-default already disabled/ }
    end
end