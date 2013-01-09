def parse_vagrant_config
  require 'yaml'
  config = {}
  
  config_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yaml'))
  if File.exists?(config_file)
    overrides = YAML.load_file(config_file)
    config.merge!(overrides)
  end
  config
end