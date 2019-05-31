require 'spec_helper'

describe '## Apache' do
    describe package('apache2'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('apache2'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(80) do
      it { should be_listening }
    end

    describe port(443) do
      it { should be_listening }
    end

    describe file('/etc/apache2/sites-enabled/00-joomla.box-http.conf') do
      it { should exist }
      its(:content) { should match /Include "\/etc\/apache2\/joomla.box-include.conf"/ }
    end

    describe file('/etc/apache2/sites-enabled/00-joomla.box-ssl.conf') do
      it { should exist }
      its(:content) { should match /Include "\/etc\/apache2\/joomla.box-include.conf"/ }
    end

    describe file('/etc/apache2/conf.d/1-box.conf') do
      it { should exist }
      its(:content) { should match /ServerName joomlatools/ }
      its(:content) { should match /SetEnv JOOMLATOOLS_BOX \d\.\d\.\d/ }
      its(:content) { should match /Protocols h2 h2c http\/1.1/ }
    end
end