require 'spec_helper'

describe '## Joomlatools' do
    let(:sudo_options) { '-u vagrant -i' } # Simulate a login as the user, so that the PATH variable is loaded

    describe '### joomlatools-console' do

        describe command('/home/vagrant/.composer/vendor/bin/joomla -V') do
          its(:stdout) { should match /Joomla Console tools \d\.\d+\.\d+/ }
        end

        describe command('/home/vagrant/.composer/vendor/bin/joomla site:create serverspectest-joomla') do
          its(:exit_status) { should eq 0 }

          describe command('mysql -s -N -uroot -proot -e "SHOW DATABASES;"') do
            its(:stdout) { should match /sites_serverspectest-joomla/ }
          end

          describe command('curl -s http://joomla.box/sites.php') do
            its(:stdout) { should match /serverspectest-joomla/ }
          end
        end

        describe command('/home/vagrant/.composer/vendor/bin/joomla site:delete serverspectest-joomla') do
          its(:exit_status) { should eq 0 }
        end
    end
end