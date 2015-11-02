Puppet::Type.newtype(:ini_setting) do

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:section) do
    desc 'The name of the section in the ini file in which the setting should be defined.' +
      'If not provided, defaults to global, top of file, sections.'
    defaultto("")
  end

  newparam(:setting) do
    desc 'The name of the setting to be defined.'
    munge do |value|
      if value =~ /(^\s|\s$)/
        Puppet.warn("Settings should not have spaces in the value, we are going to strip the whitespace")
      end
      value.lstrip.rstrip
    end
  end

  newparam(:path) do
    desc 'The ini file Puppet will ensure contains the specified setting.'
    validate do |value|
      unless (Puppet.features.posix? and value =~ /^\//) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
        raise(Puppet::Error, "File paths must be fully qualified, not '#{value}'")
      end
    end
  end

  newparam(:key_val_separator) do
    desc 'The separator string to use between each setting name and value. ' +
        'Defaults to " = ", but you could use this to override e.g. ": ", or' +
        'whether or not the separator should include whitespace.'
    defaultto(" = ")
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
  end

  newparam(:section_prefix) do
    desc 'The prefix to the section name\'s header.' +
        'Defaults to \'[\'.'
    defaultto('[')
  end

  newparam(:section_suffix) do
    desc 'The suffix to the section name\'s header.' +
        'Defaults to \']\'.'
    defaultto(']')
  end

end
