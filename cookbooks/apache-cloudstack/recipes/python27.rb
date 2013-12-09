#
# Cookbook Name:: cloudstack
# Recipe:: python27
#

python_version = node[:cloudstack][:python][:version]
python_distribute_version = node[:cloudstack][:python][:distribute][:version]
python_extract_path = "#{Chef::Config[:file_cache_path]}/Python-#{python_version}"
python_distribute_path = "#{Chef::Config[:file_cache_path]}/distribute-#{python_distribute_version}.tar.gz"

remote_file "#{Chef::Config[:file_cache_path]}/Python-#{python_version}.tar.bz2" do
  source node[:cloudstack][:python][:url]
  owner 'root'
  group 'root'
  action :create_if_missing
end

bash "Extract Python 2.7" do
  cwd ::Chef::Config[:file_cache_path]
  code <<-EOH
    tar xvf Python-#{python_version}.tar.bz2
  EOH
  not_if { ::File.exists?(python_extract_path) }
end

bash "Configure Python 2.7" do
  cwd ::Chef::Config[:file_cache_path]
  code <<-EOH
  (cd Python-#{python_version} && ./configure --prefix=/usr/local)
  (cd Python-#{python_version} && make && make altinstall)
  EOH
  only_if { ::File.exists?(python_extract_path) }
  creates "/usr/local/bin/python2.7"
end

#remote_file "#{python_distribute_path}" do
#  source node[:cloudstack][:python][:distribute][:url]
#  owner 'root'
#  group 'root'
#  action :create_if_missing
#  notifies :run, "bash[Extract Python Distribute]", :immediately
#end

bash "Extract Python Distribute" do
  cwd ::Chef::Config[:file_cache_path]
  code <<-EOH
    (wget --no-check-certificate #{node[:cloudstack][:python][:distribute][:url]})
    (tar xvf #{node[:cloudstack][:python][:distribute][:file]})
  EOH
  not_if { ::File.exists?(python_distribute_path) }
  notifies :run, "bash[Install Python Distribute]", :immediately
end

bash "Install Python Distribute" do
  cwd "#{Chef::Config[:file_cache_path]}/distribute-#{python_distribute_version}"
  code <<-EOH
  (/usr/local/bin/python2.7 ./setup.py install)
  EOH
  only_if { ::File.exists?(python_extract_path) }
  creates "/usr/local/bin/easy_install-2.7"
  notifies :run, "bash[Install Python Virtualenv]", :immediately
end

bash "Install Python Virtualenv" do
  code <<-EOH
  (/usr/local/bin/easy_install-2.7 virtualenv)
  EOH
  only_if { ::File.exists?(python_extract_path) }
  creates "/usr/local/bin/virtualenv-2.7"
end

