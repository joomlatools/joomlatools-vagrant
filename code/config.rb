#
# Author:: Gergo Erdosi (<gergo@timble.net>)
#
# Copyright 2013, Timble CVBA and Contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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