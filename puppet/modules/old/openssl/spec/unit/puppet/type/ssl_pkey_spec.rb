require 'puppet'
require 'puppet/type/ssl_pkey'
describe Puppet::Type.type(:ssl_pkey) do
  subject { Puppet::Type.type(:ssl_pkey).new(:path => '/tmp/foo.key') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:ssl_pkey).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'should accept a valid size' do
    subject[:size] = 1024
    expect(subject[:size]).to eq(1024)
  end

  it 'should not accept an invalid size' do
    expect {
      subject[:size] = :foo
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

  it 'should accept a password' do
    subject[:password] = 'foox2$bar'
    expect(subject[:password]).to eq('foox2$bar')
  end
end
