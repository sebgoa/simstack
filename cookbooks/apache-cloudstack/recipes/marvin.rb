#
# Cookbook Name:: cloudstack
# Recipe:: default
#

bash "Create Virtualenv" do
  cwd "opt/cloudstack"
  code <<-EOH
  (source marvin-dir/bin/activate &&
   pip install nose &&
   pip install /opt/cloudstack/tools/marvin/dist/Marvin-0.1.0.tar.gz &&
   nosetests --with-marvin --marvin-config=setup/dev/basic.cfg)
  EOH
end

#easy_install_package "nose" do
#  action :install
#end

#easy_install_package "marvin" do
#  cwd node[:cloudstack][:marvin][:path]
#  package_name "marvin"
#  source node[:cloudstack][:marvin][:version] 
#end