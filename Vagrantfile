require "yaml"
require "json"

# Check for required plugins and install if missing
required_plugins = %w( vagrant-puppet-install )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin} && vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

# Initialize config
def deep_merge!(target, data)
  merger = proc{|key, v1, v2|
    Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
  target.merge! data, &merger
end

_config = {
    "synced_folders" => {
        "/var/www" => File.join(Dir.pwd, "www"),
        "/home/vagrant/Projects" => File.join(Dir.pwd, "Projects")
    },
    "nfs" => !!(RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/),
    "virtualbox" => {
        "name"   => "joomlatools-box-build",
        "memory" => 1024,
        "cpus"   => 1,
        "natdnshostresolver1" => "on",
        "uartmode1" => "disconnected",
        "cpuexecutioncap" => "90"
    },
    "ip" => "33.33.33.58",
    "mount_options" => ["vers=3", "rw", "tcp", "nolock", "noacl", "async"],
    "linux_nfs_options" => ['rw', 'no_subtree_check', 'all_squash','async']
}

# Local-specific/not-git-managed config -- config.custom.yaml
begin
  deep_merge!(_config, YAML.load(File.open(File.join(Dir.pwd, "config.custom.yaml"), File::RDONLY).read))
rescue Errno::ENOENT
  # No config.custom.yaml found -- that's OK; just use the defaults.
end

CONF = _config

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "joomlatools" # Important: we use this in joomla-console to determine if we are being run in the Vagrant box or not!

  config.vm.network :private_network, ip: CONF["ip"]
  config.ssh.forward_agent = true

  if CONF.has_key?('virtualbox')
    parameters = Array['name', 'memory', 'cpus', 'natdnshostresolver1', 'uartmode1', 'cpuexecutioncap']

    config.vm.provider :virtualbox do |v|
      parameters.each { |parameter|
        if (CONF['virtualbox'].has_key?(parameter) && !CONF['virtualbox'][parameter].to_s.empty?)
          v.customize ["modifyvm", :id, "--" + parameter, CONF['virtualbox'][parameter]]
        end
      }
    end
  end

  if CONF.has_key?('synced_folders')
    CONF['synced_folders'].each { |target, source|
      if source
        config.vm.synced_folder source, target, :nfs => CONF['nfs'], :linux__nfs_options => CONF['linux_nfs_options'], :mount_options => CONF["mount_options"], :create => true
      end
    }

    # Store the shared paths as an environment variable on the box
    pwd = Dir.pwd
    pwd << '/' unless pwd.end_with?('/')

    mapping = Hash[ CONF['synced_folders'].keep_if { |key, value| value.is_a? String }.each_pair.map { |key, value| [key, value.gsub(/^\.\//, pwd)] }]

    json = mapping.to_json.gsub(/"/, '\\\\\\\\\"')
    paths = 'SetEnv BOX_SHARED_PATHS \"' + json + '\"'
    shell_cmd = '[ -d /etc/apache2/conf.d/ ] && { echo "' + paths + '" > /etc/apache2/conf.d/25-shared_paths.conf && service apache2 restart; } || echo "Apache2 is not installed yet"'

    config.vm.provision :shell, :inline => shell_cmd, :run => "always"
  end

  config.puppet_install.puppet_version = '5.5.8'
  config.puppet_install.install_url = 'https://gist.githubusercontent.com/stevenrombauts/5afcb5e103f44a38880696c8c9e95817/raw/d0517999049649c0cc85c6eaca8a05ae3f525afb/install.sh'

  # Install librarian-puppet and run it to install puppet modules prior to Puppet provisioning.
  config.vm.provision :shell, :path => "shell/librarian-puppet.sh"

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = "puppet/environments"
    puppet.environment = "box"
    puppet.manifests_path = "puppet/environments/box/manifests"
    puppet.manifest_file = ""
    puppet.module_path = ['puppet/modules', 'puppet/environments/box/modules'] # Note: --modulepath will override the environment's modulepath. See: https://puppet.com/docs/puppet/4.9/dirs_modulepath.html#using---modulepath
    puppet.options = ['--verbose', '--show_diff']
    puppet.facter = { 'fqdn' => "#{config.vm.hostname}.box" }
  end
end
