require 'spec_helper'

describe '## Cockpit' do
    describe service('cockpit'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(9090) do
      it { should be_listening }
    end

    describe file('/etc/cockpit/cockpit.conf') do
      it { should exist }
      its(:content) { should match /joomlatools.box/ }
      its(:content) { should match /AllowUnencrypted = true/ }
    end
end