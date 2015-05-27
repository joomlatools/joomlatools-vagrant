require 'pathname'
Puppet::Type.type(:x509_request).provide(:openssl) do
  desc 'Manages certificate signing requests with OpenSSL'

  commands :openssl => 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    if resource[:authentication] == :dsa
      OpenSSL::PKey::DSA.new(file, resource[:password])
    elsif resource[:authentication] == :rsa
      OpenSSL::PKey::RSA.new(file, resource[:password])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def self.check_private_key(resource)
    request = OpenSSL::X509::Request.new(File.read(resource[:path]))
    priv = self.private_key(resource)
    request.verify(priv)
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      if resource[:force] and !self.class.check_private_key(resource)
        return false
      end
      return true
    else
      return false
    end
  end

  def create
    if resource[:password]
      openssl(
        'req', '-new',
        '-key', resource[:private_key],
        '-config', resource[:template],
        '-out', resource[:path],
        '-passin', "pass:#{resource[:password]}"
      )
    else
      openssl(
        'req', '-new',
        '-key', resource[:private_key],
        '-config', resource[:template],
        '-out', resource[:path]
      )
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end

