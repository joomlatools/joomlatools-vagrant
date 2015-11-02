require 'puppet'
require 'pathname'
require 'puppet/type/ssl_pkey'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the ssl_pkey type' do
  let (:path) { '/tmp/foo.key' }
  let (:resource) { Puppet::Type::Ssl_pkey.new({:path => path}) }
  subject { Puppet::Type.type(:ssl_pkey).provider(:openssl).new(resource) }
  key = OpenSSL::PKey::RSA.new # For mocking

  it 'exists? should return true if key exists' do
    Pathname.any_instance.expects(:exist?).returns(true)
    expect(subject.exists?).to eq(true)
  end

  it 'exists? should return false if certificate does not exist' do
    Pathname.any_instance.expects(:exist?).returns(false)
    expect(subject.exists?).to eq(false)
  end

  context 'when creating a key with defaults' do
    it 'should create an rsa key' do
      OpenSSL::PKey::RSA.expects(:new).with(2048, nil).returns(key)
      File.expects(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:size] = 1024
        OpenSSL::PKey::RSA.expects(:new).with(1024, nil).returns(key)
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'should create with given password' do
        resource[:password] = '2x$5{'
        OpenSSL::PKey::RSA.expects(:new).with(2048).returns(key)
        OpenSSL::Cipher.expects(:new).with('des3')
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'should create an dsa key' do
      resource[:authentication] = :rsa
      OpenSSL::PKey::RSA.expects(:new).with(2048, nil).returns(key)
      File.expects(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        OpenSSL::PKey::RSA.expects(:new).with(1024, nil).returns(key)
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'should create with given password' do
        resource[:authentication] = :rsa
        resource[:password] = '2x$5{'
        OpenSSL::PKey::RSA.expects(:new).with(2048).returns(key)
        OpenSSL::Cipher.expects(:new).with('des3')
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  context 'when setting authentication to dsa' do
    it 'should create an dsa key' do
      resource[:authentication] = :dsa
      OpenSSL::PKey::DSA.expects(:new).with(2048, nil).returns(key)
      File.expects(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:authentication] = :dsa
        resource[:size] = 1024
        OpenSSL::PKey::DSA.expects(:new).with(1024, nil).returns(key)
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'should create with given password' do
        resource[:authentication] = :dsa
        resource[:password] = '2x$5{'
        OpenSSL::PKey::DSA.expects(:new).with(2048).returns(key)
        OpenSSL::Cipher.expects(:new).with('des3')
        File.expects(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  it 'should delete files' do
    Pathname.any_instance.expects(:delete)
    subject.destroy
  end
end
