require 'spec_helper'

# Core PHP installation
describe package('php5'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

modules = ['php5-apcu', 'php5-cli', 'php5-curl', 'php5-dev', 'php5-gd', 'php5-imagick', 'php5-intl', 'php5-json', 'php5-mcrypt', 'php5-mysql', 'php-pear', 'php5-readline', 'php5-sqlite', 'php5-xdebug']
modules.each { |package|

 describe package(package), :if => os[:family] == 'ubuntu' do
   it { should be_installed }
 end

}

# Apache module
describe package('libapache2-mod-php5'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

# HHVM
describe package('hhvm'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('hhvm'), :if => os[:family] == 'ubuntu' do
  it { should be_running }
end

describe port(9000)do
  it { should be_listening }
end

# PhpMyAdmin
describe package('phpmyadmin'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

# Composer
describe command('/usr/bin/composer --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /Composer version/ }
end

# Configuration tests
describe 'PHP config parameters' do
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

# Pecl extensions
describe command('/usr/bin/pecl list') do
  its(:stdout) { should match /oauth/ }
  its(:stdout) { should match /yaml/ }
end

describe command('/usr/bin/php -i') do
  its(:stdout) { should match /OAuth/ }
  its(:stdout) { should match /LibYAML/ }
end