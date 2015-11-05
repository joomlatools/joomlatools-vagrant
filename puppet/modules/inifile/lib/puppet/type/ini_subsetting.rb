Puppet::Type.newtype(:ini_subsetting) do

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
  end

  newparam(:subsetting) do
    desc 'The name of the subsetting to be defined.'
  end

  newparam(:subsetting_separator) do
    desc 'The separator string between subsettings. Defaults to " "'
    defaultto(" ")
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

  newparam(:quote_char) do
    desc 'The character used to quote the entire value of the setting. ' +
        %q{Valid values are '', '"' and "'". Defaults to ''.}
    defaultto('')

    validate do |value|
      unless value =~ /^["']?$/
        raise Puppet::Error, %q{:quote_char valid values are '', '"' and "'"}
      end
    end
  end

  newparam(:use_exact_match) do
    desc 'Set to true if your subsettings don\'t have values and you want to use exact matches to determine if the subsetting exists. See MODULES-2212'
    newvalues(:true, :false)
    defaultto(:false)
  end

  newproperty(:value) do
    desc 'The value of the subsetting to be defined.'
  end

end
