#
# Cookbook Name:: cloudstack
# Recipe:: python27
#

python_version = node[:cloudstack][:python][:version]
python_extract_path = "#{Chef::Config[:file_cache_path]}/Python-#{python_version}"

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
  creates "/usr/local/bin/python2.7"
end