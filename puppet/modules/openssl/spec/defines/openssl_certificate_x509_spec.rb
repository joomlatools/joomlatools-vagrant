require 'spec_helper'

describe 'openssl::certificate::x509' do
  let (:title) { 'foo' }

  context 'when passing non absolute path as base_dir' do
    let (:params) { {
      :country      => 'com',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => 'barz',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /"barz" is not an absolute path/)
    end
  end

  context 'when not passing a country' do
    let (:params) { {
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass country to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for country' do
    let (:params) { {
      :country      => true,
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when not passing an organization' do
    let (:params) { {
      :country      => 'CH',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass organization to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for organization' do
    let (:params) { {
      :country      => 'CH',
      :organization => true,
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when not passing an commonname' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass commonname to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for commonname' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => true,
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong value for ensure' do
    let (:params) { {
      :ensure       => 'foo',
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /\$ensure must be either 'present' or 'absent', got 'foo'/)
    end
  end

  context 'when passing wrong type for state' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :state        => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for locality' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :locality     => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for unit' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :unit         => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for altnames' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :altnames     => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not an Array/)
    end
  end

  context 'when passing wrong type for email' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :email        => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for days' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :days         => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /"true" does not match/)
    end
  end

  context 'when passing wrong type for base_dir' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for owner' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :owner        => true,
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for password' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :password     => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for force' do
    let (:params) { {
      :country      => 'CH',
      :organization => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :force        => 'foobar',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /"foobar" is not a boolean/)
    end
  end

  context 'when using defaults' do
    let (:params) { {
      :country      => 'com',
      :organization => 'bar',
      :commonname   => 'baz',
    } }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.cnf').with(
        :ensure  => 'present',
        :owner   => 'root'
      ).with_content(
        /countryName\s+=\s+com/
      ).with_content(
        /organizationName\s+=\s+bar/
      ).with_content(
        /commonName\s+=\s+baz/
      )
    }

    it {
      is_expected.to contain_ssl_pkey('/etc/ssl/certs/foo.key').with(
        :ensure   => 'present',
        :password => nil
      )
    }

    it {
      is_expected.to contain_x509_cert('/etc/ssl/certs/foo.crt').with(
        :ensure      => 'present',
        :template    => '/etc/ssl/certs/foo.cnf',
        :private_key => '/etc/ssl/certs/foo.key',
        :days        => 365,
        :password    => nil,
        :force       => true
      )
    }

    it {
      is_expected.to contain_x509_request('/etc/ssl/certs/foo.csr').with(
        :ensure      => 'present',
        :template    => '/etc/ssl/certs/foo.cnf',
        :private_key => '/etc/ssl/certs/foo.key',
        :password    => nil,
        :force       => true
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        :ensure => 'present',
        :owner  => 'root'
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.crt').with(
        :ensure => 'present',
        :owner  => 'root'
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.csr').with(
        :ensure => 'present',
        :owner  => 'root'
      )
    }
  end

  context 'when passing all parameters' do
    let (:params) { {
      :country      => 'com',
      :organization => 'bar',
      :commonname   => 'baz',
      :state        => 'FR',
      :locality     => 'here',
      :unit         => 'braz',
      :altnames     => ['a.com', 'b.com', 'c.com'],
      :email        => 'contact@foo.com',
      :days         => 4567,
      :owner        => 'www-data',
      :password     => '5r$}^',
      :force        => false,
      :base_dir     => '/tmp/foobar',
    } }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.cnf').with(
        :ensure  => 'present',
        :owner   => 'www-data'
      ).with_content(
        /countryName\s+=\s+com/
      ).with_content(
        /stateOrProvinceName\s+=\s+FR/
      ).with_content(
        /localityName\s+=\s+here/
      ).with_content(
        /organizationName\s+=\s+bar/
      ).with_content(
        /organizationalUnitName\s+=\s+braz/
      ).with_content(
        /commonName\s+=\s+baz/
      ).with_content(
        /emailAddress\s+=\s+contact@foo\.com/
      ).with_content(
        /subjectAltName\s+=\s+"DNS: a\.com, DNS: b\.com, DNS: c\.com"/
      )
    }

    it {
      is_expected.to contain_ssl_pkey('/tmp/foobar/foo.key').with(
        :ensure   => 'present',
        :password => '5r$}^'
      )
    }

    it {
      is_expected.to contain_x509_cert('/tmp/foobar/foo.crt').with(
        :ensure      => 'present',
        :template    => '/tmp/foobar/foo.cnf',
        :private_key => '/tmp/foobar/foo.key',
        :days        => 4567,
        :password    => '5r$}^',
        :force       => false
      )
    }

    it {
      is_expected.to contain_x509_request('/tmp/foobar/foo.csr').with(
        :ensure      => 'present',
        :template    => '/tmp/foobar/foo.cnf',
        :private_key => '/tmp/foobar/foo.key',
        :password    => '5r$}^',
        :force       => false
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.key').with(
        :ensure => 'present',
        :owner  => 'www-data'
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.crt').with(
        :ensure => 'present',
        :owner  => 'www-data'
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.csr').with(
        :ensure => 'present',
        :owner  => 'www-data'
      )
    }
  end
end
