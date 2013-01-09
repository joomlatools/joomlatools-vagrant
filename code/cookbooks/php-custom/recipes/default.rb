#
# Author:: Gergo Erdosi (<gergo@timble.net>)
# Cookbook Name:: php-custom
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

# Install PHP packages
pkgs = %w( php-apc php5-curl php5-gd php5-imagick php5-mcrypt php5-mysql php5-xdebug )
pkgs.each do |pkg|
  package pkg
end

# Configure Xdebug
template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source 'xdebug.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
end