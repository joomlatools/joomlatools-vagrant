require 'spec_helper'

describe '## MySQL' do
    describe package('mariadb-server-10.3'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe service('mysql'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }

      describe command('sudo systemctl status mysqld') do
         its(:exit_status) { should eq 0 }
         its(:stdout) {  }
      end
    end

    describe file('/etc/mysql/my.cnf') do
      it { should exist }
      its(:content) { should match /\/var\/run\/mysqld\/mysqld.sock/ }
    end

    describe port(3306) do
      it { should be_listening }
    end

    describe command('mysql -u root -proot  -e ";"') do
      its(:exit_status) { should eq 0 }
    end
end