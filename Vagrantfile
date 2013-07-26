require 'yaml'

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "joomlatools.dev"

  config.vm.network :private_network, ip: "192.168.56.66"
    config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "joomlatools-box"]
  end

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/

  custom_config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yaml'))
  custom_config = YAML.load_file(custom_config_file)

  if custom_config and custom_config.has_key?('synced_folders')
    custom_config['synced_folders'].each { |from, to|
      config.vm.synced_folder from, to, :nfs => true, :create => true
    }
  end

  config.vm.provision :shell, :inline => "sudo apt-get update"
  config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=root
controluser_password=awesome" > /etc/phpmyadmin.facts;'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.options = ['--verbose']
  end
end
