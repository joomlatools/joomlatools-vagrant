require 'spec_helper'

describe '## PHP' do

    describe '### Core PHP installation' do
        describe package('php7.1-cli'), :if => os[:family] == 'ubuntu' do
          it { should be_installed }
        end

        modules = ['php-apcu', 'php7.1-cli', 'php7.1-curl', 'php7.1-dev', 'php7.1-gd', 'php-imagick', 'php7.1-intl', 'php7.1-json', 'php7.1-mcrypt', 'php7.1-mysql', 'php-pear', 'php7.1-readline', 'php7.1-sqlite3', 'php-xdebug', 'php-oauth', 'php-yaml']
        modules.each { |package|
          describe package(package), :if => os[:family] == 'ubuntu' do
            it { should be_installed }
          end
        }

        describe service('php-fpm') do
          it { should be_enabled }
          it { should be_running.under('upstart') }
        end

        describe '### PHP config parameters' do
            context php_config('sendmail_path') do
              its(:value) { should match /\/home\/vagrant\/.rvm\/gems\/ruby-2.2.6\/bin\/catchmail -fnoreply@example.com/ }
            end

            context php_config('xdebug.profiler_output_dir') do
              its(:value) { should eq '/var/www/' }
            end

            context php_config('xdebug.remote_port') do
              its(:value) { should eq 9000 }
            end

            context php_config('xdebug.remote_host') do
              its(:value) { should eq '33.33.33.1' }
            end
        end
    end

    describe '### PHP tools' do
        describe file('/usr/share/phpmyadmin/config.inc.php'), :if => os[:family] == 'ubuntu' do
          it { should exist }
        end

        describe command('/usr/local/bin/composer --version') do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /Composer version/ }
        end

        ['/home/vagrant/scripts/apc-dashboard.php', '/home/vagrant/scripts/apcu.php', '/home/vagrant/scripts/apc.php'].each do |path|
            describe file(path) do
                it { should exist }
                its(:content) { should match /apc/ }
            end
        end

        describe file('/usr/share/webgrind/config.php') do
            it { should exist }
            its(:content) { should match /Webgrind_Config/ }
        end

        describe file('/etc/apache2/sites-available/10-webgrind.conf') do
          it { should exist }
          its(:content) { should match /ServerAlias webgrind.joomla.box/ }
          its(:content) { should match /DocumentRoot \/usr\/share\/webgrind/ }
        end

        describe file('/etc/apache2/conf-available/joomla.box.conf') do
          its(:content) { should match /Alias \/apc \/home\/vagrant\/scripts\/apc-dashboard.php/ }
          its(:content) { should match /Alias \/phpinfo \/home\/vagrant\/scripts\/phpinfo.php/ }
        end

    end

end