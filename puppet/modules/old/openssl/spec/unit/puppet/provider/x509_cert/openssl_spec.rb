require 'puppet'
require 'pathname'
require 'puppet/type/x509_cert'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the x509_cert type' do
  let (:path) { '/tmp/foo.crt' }
  let (:resource) { Puppet::Type::X509_cert.new({:path => path}) }
  subject { Puppet::Type.type(:x509_cert).provider(:openssl).new(resource) }

  context 'when not forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      Pathname.any_instance.expects(:exist?).returns(true)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if certificate does not exist' do
      Pathname.any_instance.expects(:exist?).returns(false)
      expect(subject.exists?).to eq(false)
    end

    it 'should create a certificate with the proper options' do
      subject.expects(:openssl).with(
        'req', '-config', '/tmp/foo.cnf', '-new', '-x509',
        '-days', 3650,
        '-key', '/tmp/foo.key',
        '-out', '/tmp/foo.crt'
      )
      subject.create
    end

    context 'when using password' do
      it 'should create a certificate with the proper options' do
        resource[:password] = '2x6${'
        subject.expects(:openssl).with(
          'req', '-config', '/tmp/foo.cnf', '-new', '-x509',
          '-days', 3650,
          '-key', '/tmp/foo.key',
          '-out', '/tmp/foo.crt',
          '-passin', 'pass:2x6${'
        )
        subject.create
      end
    end
  end

  context 'when forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      resource[:force] = true
      File.stubs(:read)
      Pathname.any_instance.expects(:exist?).returns(true)
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      OpenSSL::X509::Certificate.stubs(:new).returns(c)
      OpenSSL::PKey::RSA.expects(:new)
      OpenSSL::X509::Certificate.any_instance.expects(:check_private_key).returns(true)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if certificate exists and is not synced' do
      resource[:force] = true
      File.stubs(:read)
      Pathname.any_instance.expects(:exist?).returns(true)
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      OpenSSL::X509::Certificate.stubs(:new).returns(c)
      OpenSSL::PKey::RSA.expects(:new)
      OpenSSL::X509::Certificate.any_instance.expects(:check_private_key).returns(false)
      expect(subject.exists?).to eq(false)
    end

    it 'exists? should return false if certificate does not exist' do
      resource[:force] = true
      Pathname.any_instance.expects(:exist?).returns(false)
      expect(subject.exists?).to eq(false)
    end
  end

  it 'should delete files' do
    Pathname.any_instance.expects(:delete)
    subject.destroy
  end
end
