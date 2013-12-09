#
# Cookbook Name:: cloudstack
# Recipe:: default
#

for p in ["ntp", "java-1.6.0-openjdk", "java-1.6.0-openjdk-devel", "tomcat6", "mysql", "mysql-server", "genisoimage", "git", "epel-release", "python-setuptools", "python-devel"]
  package p do
    action :install
  end
end

git "#{node[:cloudstack][:git][:install_path]}" do
  repository node[:cloudstack][:git][:repo]
  revision node[:cloudstack][:git][:branch]
  action :sync
end

bash "build from source" do
  code <<-EOH
    source /etc/profile.d/maven.sh
    cd /opt/cloudstack
    mvn -Pdeveloper -Dsimulator -DskipTests clean install
  EOH
end

easy_install_package "nose" do
  action :install
end

easy_install_package "marvin" do
  cwd node[:cloudstack][:marvin][:path]
  package_name "marvin"
  source node[:cloudstack][:marvin][:version] 
end

execute "service iptables stop" do
end

execute "service mysqld restart" do
  notifies :run, "bash[Setup CloudStack db]", :immediately
end

bash "Setup CloudStack db" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    mvn -Pdeveloper -pl developer -Ddeploydb
    mvn -Pdeveloper -pl developer -Ddeploydb-simulator
  EOH
  notifies :run, "bash[Start CloudStack Jetty server]",  :immediately
  notifies :run, "execute[service iptables stop]", :delayed
  action :nothing
end

bash "Start CloudStack Jetty server" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    nohup mvn -pl client jetty:run &> /tmp/cloudstack.out &  
  EOH
  notifies :run, "bash[Start AWS API Jetty server]", :immediately
  action :nothing
end

bash "Start AWS API Jetty server" do
  cwd node[:cloudstack][:git][:install_path]
  code <<-EOH
    nohup mvn -Pawsapi -pl :cloud-awsapi jetty:run &> /tmp/cloudstack-awsapi.out &  
  EOH
  action :nothing
end
