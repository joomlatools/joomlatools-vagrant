require 'spec_helper'

describe '## Miscellaneous' do

    describe '### CloudCommander' do
        describe service('cloudcommander'), :if => os[:family] == 'ubuntu' do
          it { should be_enabled }
          it { should be_running }
        end

        describe port(8001) do
          it { should be_listening }
        end

        describe command('npm -g list cloudcmd') do
          its(:exit_status) { should eq 0}
        end

        describe file('/etc/apache2/joomla.box-include.conf') do
          it { should exist }
          its(:content) { should match /Redirect permanent \/filebrowser http:\/\/joomla.box:8001\/fs\/var\/www/ }
        end
     end

    describe '### Wetty' do
        describe service('wetty'), :if => os[:family] == 'ubuntu' do
          it { should be_enabled }
          it { should be_running }
        end

        describe port(3000) do
          it { should be_listening }
        end

        describe command('sudo yarn global list') do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /wetty@\d\.\d+\.\d+/ }
        end

        describe file('/etc/apache2/joomla.box-include.conf') do
          its(:content) { should match /Redirect permanent \/terminal http:\/\/joomla.box\/wetty/ }
        end
     end

     describe '### PimpMyLog' do
        describe file('/etc/apache2/joomla.box-include.conf') do
          its(:content) { should match /Alias \/pimpmylog \/usr\/share\/pimpmylog\// }
        end

        describe file("/usr/share/pimpmylog/index.php") do
            it { should exist }
            its(:content) { should match /pimpmylog/ }
        end

        ['apache2', 'mysql'].each do |conf|
            describe file("/usr/share/pimpmylog/config.user.d/#{conf}.json") do
                it { should exist }
            end
        end
     end

end