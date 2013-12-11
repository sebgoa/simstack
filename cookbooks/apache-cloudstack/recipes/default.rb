#
# Cookbook Name:: cloudstack
# Recipe:: default
#

include_recipe "apache-cloudstack::maven"
include_recipe "apache-cloudstack::python27"

for p in ["ntp", "tomcat6", "mysql", "mysql-server", "git", "python-devel"]
  package p do
    action :install
  end
end

git "#{node[:cloudstack][:git][:install_path]}" do
  repository node[:cloudstack][:git][:repo]
  revision node[:cloudstack][:git][:branch]
  action :sync
end

bash "Build from source" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    virtualenv-2.7 marvin-dir
    source marvin-dir/bin/activate
    mvn -Pdeveloper -Dsimulator -DskipTests clean install
    deactivate
  EOH
  notifies :run, "execute[service mysqld restart]", :immediately
end

execute "service iptables stop" do
  action :nothing
end

execute "service mysqld restart" do
  notifies :run, "bash[Setup CloudStack db]", :immediately
end

bash "Setup CloudStack db" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    (mvn -Pdeveloper -pl developer -Ddeploydb)
    (mvn -Pdeveloper -pl developer -Ddeploydb-simulator)
  EOH
  notifies :run, "bash[Start CloudStack Jetty server]",  :immediately
  notifies :run, "execute[service iptables stop]", :delayed
  action :nothing
end

bash "Start CloudStack Jetty server" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    (killall java)
    (nohup mvn -pl client jetty:run &> /tmp/cloudstack.out &) 
  EOH
  notifies :run, "bash[Start AWS API Jetty server]", :delayed
  action :nothing
end

bash "Start AWS API Jetty server" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    (nohup mvn -Pawsapi -pl :cloud-awsapi jetty:run &> /tmp/cloudstack-awsapi.out &) 
  EOH
  action :nothing
end
