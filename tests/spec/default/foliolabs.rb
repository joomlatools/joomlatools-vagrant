require 'spec_helper'

describe '## Foliolabs' do
    let(:sudo_options) { '-u vagrant -i' } # Simulate a login as the user, so that the PATH variable is loaded

    describe '### joomlatools-folioshell' do

        describe command('/home/vagrant/.composer/vendor/bin/folioshell -V') do
          its(:stdout) { should match /FolioShell - WordPress Console tools \d\.\d+\.\d+/ }
        end

        describe command('/home/vagrant/.composer/vendor/bin/folioshell site:create serverspectest-wp') do
          its(:exit_status) { should eq 0 }

          describe command('mysql -s -N -uroot -proot -e "SHOW DATABASES;"') do
            its(:stdout) { should match /sites_serverspectest-wp/ }
          end

          describe command('curl -s http://joomla.box/sites.php') do
            its(:stdout) { should match /serverspectest-wp/ }
          end
        end

        describe command('/home/vagrant/.composer/vendor/bin/folioshell site:delete serverspectest-wp') do
          its(:exit_status) { should eq 0 }
        end
    end
end