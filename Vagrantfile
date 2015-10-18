require "yaml"
require "json"

# Check for required plugins and install if missing
required_plugins = %w( vagrant-triggers )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
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
    "nfs" => !!(RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/)
}

# Local-specific/not-git-managed config -- config.custom.yaml
begin
  deep_merge!(_config, YAML.load(File.open(File.join(Dir.pwd, "config.custom.yaml"), File::RDONLY).read))
rescue Errno::ENOENT
  # No config.custom.yaml found -- that's OK; just use the defaults.
end

CONF = _config

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "joomlatools.dev"

  config.vm.network :private_network, ip: "33.33.33.58"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "joomlatools-box-build"]
  end

  if CONF.has_key?('synced_folders')
    CONF['synced_folders'].each { |target, source|
      if source
        config.vm.synced_folder source, target, :nfs => CONF['nfs'], :linux__nfs_options => ['rw', 'no_subtree_check', 'all_squash','async'], :create => true
      end
    }

    # Store the shared paths as an environment variable on the box
    pwd = Dir.pwd
    pwd << '/' unless pwd.end_with?('/')

    mapping = Hash[ CONF['synced_folders'].keep_if { |key, value| value.is_a? String }.each_pair.map { |key, value| [key, value.gsub(/^\.\//, pwd)] }]

    json = mapping.to_json.gsub(/"/, '\\\\\\\\\"')
    paths = 'SetEnv BOX_SHARED_PATHS \"' + json + '\"'
    shell_cmd = '[ -d /etc/apache2/conf.d ] && { echo "' + paths + '" > /etc/apache2/conf-available/shared_paths.conf && service apache2 restart; } || echo "Apache2 is not installed yet"'

    config.vm.provision :shell, :inline => shell_cmd, :run => "always"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ['--verbose']
    puppet.facter = {
        "pma_mysql_root_password"  => "root",
        "pma_controluser_password" => "awesome"
    }
  end

  config.trigger.before :destroy do
    run_remote "/home/vagrant/triggers/backup.sh"
  end
end
