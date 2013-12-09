#
# Cookbook Name:: cloudstack
# Recipe:: maven
#

#Installing openjdk here 
for p in ["java-1.6.0-openjdk", "java-1.6.0-openjdk-devel"]
  package p do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/apache-maven-3.0.5-bin.tar.gz" do
  source node[:cloudstack][:maven][:url]
  owner 'root'
  group 'root'
  action :create_if_missing
end

bash "Install Maven" do
  user "root"
  cwd ::Chef::Config[:file_cache_path]
  code <<-EOH
    tar xzf apache-maven-3.0.5-bin.tar.gz -C /usr/local
    cd /usr/local
    ln -s apache-maven-3.0.5 maven
    touch /etc/profile.d/maven.sh
    echo 'export M2_HOME=/usr/local/maven' > /etc/profile.d/maven.sh
    echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /etc/profile.d/maven.sh 
    source /etc/profile.d/maven.sh
  EOH
  creates "/usr/local/maven"
end