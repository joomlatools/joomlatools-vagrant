require 'spec_helper'

describe package('mysql-server'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('mysql'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

