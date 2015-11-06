require 'spec_helper'

describe 'hhvm', :type => :class do
  let(:facts) { { :osfamily        => 'Debian',
                  :lsbdistid       => 'Debian',
                  :operatingsystem => 'Debian',
                  :path            => '/usr/local/bin:/usr/bin:/bin' } }

  describe 'when called with no parameters on Debian' do
    it {
      should contain_package('hhvm').with({
        'ensure' => 'installed',
      })
      should contain_class('hhvm::repo')
      should_not contain_class('hhvm::pgsql')
      should contain_class('hhvm::config')
      should contain_class('hhvm::service')
    }
  end

  describe 'when pgsql is enabled' do
    let(:params) { { :pgsql => true, } }
    it {
      should contain_class('hhvm::pgsql')
    }
  end
  describe 'when manage_repos is disabled' do
    let(:params) { { :manage_repos => false, } }
    it {
      should_not contain_class('php::repo')
    }
  end
end
