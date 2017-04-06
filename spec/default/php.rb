require 'spec_helper'

describe '## PHP' do

    describe '### Core PHP installation' do
        describe package('php5'), :if => os[:family] == 'ubuntu' do
          it { should be_installed }
        end

        modules = ['php5-apcu', 'php5-cli', 'php5-curl', 'php5-dev', 'php5-gd', 'php5-imagick', 'php5-intl', 'php5-json', 'php5-mcrypt', 'php5-mysql', 'php-pear', 'php5-readline', 'php5-sqlite', 'php5-xdebug']
        modules.each { |package|
          describe package(package), :if => os[:family] == 'ubuntu' do
            it { should be_installed }
          end
        }

        describe '### PHP config parameters' do
            context php_config('sendmail_path') do
              its(:value) { should match /\/home\/vagrant\/.rvm\/gems\/ruby-2.2.1\/bin\/catchmail -fnoreply@example.com/ }
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

    describe '### Apache module' do
        describe package('libapache2-mod-php5'), :if => os[:family] == 'ubuntu' do
          it { should be_installed }
        end
    end

    describe '### HHVM' do
        describe package('hhvm'), :if => os[:family] == 'ubuntu' do
          it { should be_installed }
        end

        describe service('hhvm'), :if => os[:family] == 'ubuntu' do
          it { should be_running }
        end

        describe port(9000)do
          it { should be_listening }
        end
    end

    describe '### PHP tools' do
        describe package('phpmyadmin'), :if => os[:family] == 'ubuntu' do
          it { should be_installed }
        end

        describe command('/usr/bin/composer --version') do
          its(:exit_status) { should eq 0 }
          its(:stdout) { should match /Composer version/ }
        end

        ['/home/vagrant/scripts/apc-dashboard.php', '/home/vagrant/scripts/apcu.php', '/home/vagrant/scripts/apc.php'].each do |path|
            describe file(path) do
                its(:content) { should match /apc/ }
            end
        end

        describe file('/home/vagrant/scripts/apc-dashboard.php') do
           it { should exist }
        end

        describe file('/etc/apache2/sites-available/00-joomla.box.conf') do
          its(:content) { should match /Alias \/apc \/home\/vagrant\/scripts\/apc-dashboard.php/ }
          its(:content) { should match /Alias \/phpinfo \/home\/vagrant\/scripts\/phpinfo.php/ }
        end
    end

    describe '### PECL' do
        describe command('/usr/bin/pecl list') do
          its(:stdout) { should match /oauth/ }
          its(:stdout) { should match /yaml/ }
        end

        describe command('/usr/bin/php -i') do
          its(:stdout) { should match /OAuth/ }
          its(:stdout) { should match /LibYAML/ }
        end
    end

end