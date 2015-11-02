require 'puppet'
require 'puppet/type/x509_request'
describe Puppet::Type.type(:x509_request) do
  subject { Puppet::Type.type(:x509_request).new(:path => '/tmp/foo.csr') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_request).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'should accept valid private key' do
    subject[:private_key] = '/tmp/foo.key'
    expect(subject[:private_key]).to eq('/tmp/foo.key')
  end

  it 'should not accept non absolute private key' do
    expect {
      subject[:private_key] = 'foo.key'
    }.to raise_error(Puppet::Error, /Path must be absolute: foo\.key/)
  end

  it 'should accept valid template' do
    subject[:template] = '/tmp/foo.cnf'
    expect(subject[:template]).to eq('/tmp/foo.cnf')
  end

  it 'should not accept non absolute template' do
    expect {
      subject[:template] = 'foo.cnf'
    }.to raise_error(Puppet::Error, /Path must be absolute: foo\.cnf/)
  end

  it 'should accept a password' do
    subject[:password] = 'foox2$bar'
    expect(subject[:password]).to eq('foox2$bar')
  end

  it 'should accept a valid force parameter' do
    subject[:force] = true
    expect(subject[:force]).to eq(:true)
  end

  it 'should not accept a bad force parameter' do
    expect {
      subject[:force] = :foo
    }.to raise_error(Puppet::Error, /Invalid value :foo/)
  end

  it 'should accept a valid authentication' do
    subject[:authentication] = :rsa
    expect(subject[:authentication]).to eq(:rsa)
    subject[:authentication] = :dsa
    expect(subject[:authentication]).to eq(:dsa)
  end

  it 'should not accept an invalid authentication' do
    expect {
      subject[:authentication] = :foo
    }.to raise_error(Puppet::Error, /Invalid value :foo/)
  end
end
