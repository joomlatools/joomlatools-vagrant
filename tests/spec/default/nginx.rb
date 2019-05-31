require 'spec_helper'

describe '## Nginx' do
    describe package('nginx'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('nginx'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(81) do
      it { should be_listening }
    end

    describe port(8443) do
      it { should be_listening }
    end

    describe file('/etc/nginx/php.conf') do
      it { should exist }
      its(:content) { should match /\/opt\/php\/php-fpm\.sock/ }
    end

    describe file('/etc/nginx/sites-available/joomla.box.conf') do
      it { should exist }
      its(:content) { should match /joomla\.box/ }
    end

    describe file('/etc/nginx/sites-available/joomla.box-ssl.conf') do
      it { should exist }
      its(:content) { should match /joomla\.box/ }
    end

    describe file('/etc/nginx/sites-enabled/joomla.box.conf') do
      it { should be_symlink }
    end

    describe file('/etc/nginx/sites-enabled/joomla.box-ssl.conf') do
      it { should be_symlink }
    end

    describe command("curl --http2 -sI -k https://joomla.box:8443/ -o/dev/null -w \'%{http_version}\'") do
        its(:stdout) { should eq "2" }
    end
end