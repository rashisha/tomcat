#
# Cookbook Name:: tomcat7
# Recipe:: default
#
# Copyright 2011,
#
# All rights reserved - Do Not Redistribute
#

tc7ver = node["tomcat7"]["version"]
tc7tarball = "apache-tomcat-#{tc7ver}.tar.gz"
tc7url = "http://archive.apache.org/dist/tomcat/tomcat-7/v#{tc7ver}/bin/#{tc7tarball}"
tc7target = node["tomcat7"]["target"]
tc7user = node["tomcat7"]["user"]
tc7group = node["tomcat7"]["group"]

# Get the tomcat binary 
remote_file "/tmp/#{tc7tarball}" do
    source "#{tc7url}"
    mode "0644"
	action :create
end

# Create group
group "#{tc7group}" do
    action :create
end

# Create user
user "#{tc7user}" do
    comment "Tomcat7 user"
    gid "#{tc7group}"
    home "#{tc7target}"
    shell "/bin/false"
    system true
    action :create
end

# Create base folder
directory "#{tc7target}/apache-tomcat-#{tc7ver}" do
    owner "#{tc7user}"
    group "#{tc7group}"
    mode "0755"
    action :create
end

# Extract
execute "tar" do
    user "#{tc7user}"
    group "#{tc7group}"
    installation_dir = "#{tc7target}"
    cwd installation_dir
    command "tar zxf /tmp/#{tc7tarball}"
    action :run
end

# Set the symlink
link "#{tc7target}/tomcat" do
    to "apache-tomcat-#{tc7ver}"
    link_type :symbolic
end

# Add the init-script
template "/etc/init.d/tomcat7" do
		source "init-rh.erb"
		owner "root"
		group "root"
		mode "0755"
    end
    execute "init-rh" do
		user "root"
		group "root"
		command "chkconfig --add tomcat7"
		action :run
    end
	
# Start service
service "tomcat7" do
    service_name "tomcat7"
	supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
    
end

# Config from template
template "#{tc7target}/tomcat/conf/server.xml" do
    source "server.xml.erb"
    owner "#{tc7user}"
    group "#{tc7group}"
    mode "0644"
	notifies :restart, resources(:service => "tomcat7")
end


#tomcat_pkgs = [ 'tomcat7', 'tomcat-admin']

#tomcat_pkgs.each do |pkg|
 # package pkg do
 #   action :install
 #end
#end


template "/#{tc7target}/tomcat/conf/context.xml" do
  source "context.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "tomcat7")
end

# Delete the extracted files before deployment
execute 'Delete previous war file' do
  command 'rm -r /var/lib/tomcat/webapps/ServletDBLog4jExample'
  action :nothing
end

#cookbook_file '/var/lib/tomcat/webapps/ServletDBLog4jExample.war' do
#  source 'ServletDBLog4jExample.war '
#  owner 'root'
#  group 'root'
#  mode '0755'
#  action :create
#  notifies :restart, resources(:service => "tomcat7"), :immediately
#end

#ruby_block 'wait for tomcat' do
 # block do
 #   true until ::File.exists?('/var/lib/tomcat/webapps/ServletDBLog4jExample/WEB-INF/web.xml')
 # end
#end

#template "/var/lib/tomcat/webapps/ServletDBLog4jExample/WEB-INF/web.xml" do
 # source "web.xml.erb"
  #owner "root"
 # group "root"
 # mode "0644"
 # notifies :restart, resources(:service => "tomcat7")
#end