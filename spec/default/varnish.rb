require 'spec_helper'

describe '## Varnish' do
    describe package('varnish'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('varnish'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8080) do
      it { should be_listening }
    end
end