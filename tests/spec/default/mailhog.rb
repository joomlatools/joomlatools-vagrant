require 'spec_helper'

describe '## Mailhog' do
    describe service('mailhog'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(1025) do
      it { should be_listening }
    end

    describe file('/etc/apache2/joomla.box-include.conf') do
      it { should exist }
      its(:content) { should match /Redirect permanent \/mailhog http:\/\/joomla.box:8025/ }
    end

    describe port(8025) do
      it { should be_listening }
    end
end