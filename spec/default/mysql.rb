require 'spec_helper'

describe '## MySQL' do
    describe package('mariadb-server-10.2'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('mysql'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(3306) do
      it { should be_listening }
    end

    describe command('mysql -u root -proot  -e ";"') do
      its(:exit_status) { should eq 0 }
    end
end