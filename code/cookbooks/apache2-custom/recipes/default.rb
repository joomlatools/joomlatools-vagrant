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
      :ip => site['ip'],
      :name => site['name']
    )
  end
  
  apache_site site['name'] do
    enable
  end
end