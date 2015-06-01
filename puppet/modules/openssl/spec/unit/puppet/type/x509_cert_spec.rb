require 'puppet'
require 'puppet/type/x509_cert'
describe Puppet::Type.type(:x509_cert) do
  subject { Puppet::Type.type(:x509_cert).new(:path => '/tmp/foo') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_cert).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'should accept valid days' do
    subject[:days] = 365
    expect(subject[:days]).to eq(365)
  end

  it 'should not accept invalid days' do
    expect {
      subject[:days] = :foo
    }.to raise_error(Puppet::Error, /Invalid value :foo/)
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
