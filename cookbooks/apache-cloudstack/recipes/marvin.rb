#
# Cookbook Name:: cloudstack
# Recipe:: default
#

easy_install_package "nose" do
  action :install
end

easy_install_package "marvin" do
  cwd node[:cloudstack][:marvin][:path]
  package_name "marvin"
  source node[:cloudstack][:marvin][:version] 
end