require 'spec_helper'

describe '## Joomlatools' do
    let(:sudo_options) { '-u vagrant -i' } # Simulate a login as the user, so that the PATH variable is loaded

    describe '### joomlatools-console' do

        describe command('joomla -V') do
          its(:stdout) { should match /Joomla Console tools version \d\.\d+\.\d+/ }
        end

        describe command('joomla site:create serverspectest') do
          its(:exit_status) { should eq 0 }

          describe command('mysql -s -N -uroot -proot -e "SHOW DATABASES;"') do
            its(:stdout) { should match /sites_serverspectest/ }
          end

          describe command('curl -s http://joomla.box/sites.php') do
            its(:stdout) { should match /serverspectest/ }
          end
        end

        describe command('joomla site:delete serverspectest') do
          its(:exit_status) { should eq 0 }
        end
    end
end