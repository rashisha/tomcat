#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version = node['tomcat']['version'].to_s
node["tomcat"]["user"] = "tomcat#{version}"
node["tomcat"]["group"] = "tomcat#{version}"
node["tomcat"]["home"] = "/usr/share/tomcat#{version}"
node["tomcat"]["base"] = "/var/lib/tomcat#{version}"
node["tomcat"]["config_dir"] = "/etc/tomcat#{version}"
config_dir = node["tomcat"]["config_dir"]
node["tomcat"]["log_dir"] = "/var/log/tomcat#{version}"
node["tomcat"]["tmp_dir"] = "/tmp/tomcat#{version}-tmp"
node["tomcat"]["work_dir"] = "/var/cache/tomcat#{version}"
node["tomcat"]["context_dir"] = "#{config_dir}/Catalina/localhost"
node["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{version}/webapps"
tomcat_pkgs = [ "tomcat#{version}", "tomcat#{version}-admin"]


tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/tomcat#{version}/context.xml" do
  source "context.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:tomcat => node['tomcat'].to_hash)
  notifies :restart, resources(:service => "tomcat")
end


template "/etc/tomcat#{version}/server.xml" do
  source "server.tomcat#{version}.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:tomcat => node['tomcat'].to_hash)
  notifies :restart, resources(:service => "tomcat")
end

service "tomcat" do
  service_name "tomcat#{version}"
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end

# Delete the extracted files before deployment
execute 'Delete previous war file' do
  owner "root"
  command 'rm -r /var/lib/tomcat/webapps/ServletDBLog4jExample'
  action :nothing
end

cookbook_file '/var/lib/tomcat/webapps/ServletDBLog4jExample.war' do
  source 'ServletDBLog4jExample.war '
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

ruby_block 'wait for tomcat' do
  block do
    true until ::File.exists?('/var/lib/tomcat/webapps/ServletDBLog4jExample/WEB-INF/web.xml')
  end
end