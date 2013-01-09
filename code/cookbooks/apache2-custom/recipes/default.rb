#
# Author:: Gergo Erdosi (<gergo@timble.net>)
# Cookbook Name:: apache-custom
# Recipe:: default
#
# Copyright 2012, Timble CVBA and Contributors.
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

node['apache']['sites'].each do |site|
  bash "create_symlink_#{site['name'].gsub(/-\./, '_')}" do
    user 'root'
    group 'root'
    cwd "#{node['apache']['sites_dir']}/#{site['name']}"
    code <<-EOH
      [ -L public ] || ln -s source public
    EOH
  end
  
  template "#{node['apache']['dir']}/sites-available/#{site['name']}" do
    source 'site.erb'
    owner 'root'
    group node['apache']['root_group']
    mode 00644
    notifies :restart, 'service[apache2]'
    action :create_if_missing
    variables(
      :name => site['name']
    )
  end
  
  apache_site site['name'] do
    enable
  end
end