#
# Cookbook Name:: cloudstack
# Recipe:: package
#

case node['platform']
when "ubuntu", "debian"
  include_recipe "apt"

  apt_repository "basho" do
    uri "http://apt.basho.com"
    distribution node['lsb']['codename']
    components ["main"]
    key "http://apt.basho.com/gpg/basho.apt.key"
  end

  package "cloudstack-management" do
    action :install
    version package_version
  end

when "centos", "redhat"
  include_recipe "yum"

  yum_key "RPM-GPG-KEY-basho" do
    url "http://yum.basho.com/gpg/RPM-GPG-KEY-basho"
    action :add
  end

  yum_repository "cloudstack" do
    repo_name "cloudstack"
    description "CloudStack Community Repo"
    url "http://yum.basho.com/el/#{platform_version}/products/x86_64/"
    key "RPM-GPG-KEY-basho"
    action :add
  end