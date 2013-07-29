require "yaml"

# Initialize config
def deep_merge!(target, data)
  merger = proc{|key, v1, v2|
    Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
  target.merge! data, &merger
end

_config = {
    "synced_folders" => {
        "/var/www" => "./www"
    }
}

# Local-specific/not-git-managed config -- config.local.yaml
begin
  deep_merge!(_config, YAML.load(File.open(File.join(File.dirname(__FILE__), "config.local.yaml"), File::RDONLY).read))
rescue Errno::ENOENT
    # No vagrantconfig_local.yaml found -- that's OK; just use the defaults.
end

CONF = _config

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "joomlatools.dev"

  config.vm.network :private_network, ip: "33.33.33.58"
    config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "joomlatools-box"]
  end

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/

  if CONF.has_key?('synced_folders')
    CONF['synced_folders'].each { |target, source|
      config.vm.synced_folder source, target, :nfs => nfs_setting, :create => true
    }
  end

  config.vm.provision :shell, :inline => "sudo apt-get update"
  config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=root
controluser_password=awesome" > /etc/phpmyadmin.facts;'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ['--verbose']
  end
end
