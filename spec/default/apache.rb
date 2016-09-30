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
end