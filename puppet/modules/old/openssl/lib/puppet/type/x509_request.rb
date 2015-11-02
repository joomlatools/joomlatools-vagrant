require 'pathname'
Puppet::Type.newtype(:x509_request) do
  desc 'An x509 certificate signing request'

  ensurable

  newparam(:path, :namevar => true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:force, :boolean => true) do
    desc 'Whether to replace the certificate if the private key mismatches'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:password) do
    desc 'The optional password for the private key'
  end

  newparam(:template) do
    defaultto do
      path = Pathname.new(@resource[:path])
      "#{path.dirname}/#{path.basename(path.extname)}.cnf"
    end
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:private_key) do
    defaultto do
      path = Pathname.new(@resource[:path])
      "#{path.dirname}/#{path.basename(path.extname)}.key"
    end
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:authentication) do
    desc "The authentication algorithm: 'rsa' or 'dsa'"
    newvalues /[dr]sa/
    defaultto :rsa
  end

  autorequire(:x509_cert) do
    path = Pathname.new(self[:private_key])
    "#{path.dirname}/#{path.basename(path.extname)}"
  end

  autorequire(:file) do
    self[:private_key]
  end
end
