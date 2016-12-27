#
# Cookbook Name:: my_nginx_app
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

    nginx_site "my_site" do
      name 'my_site.conf'
      template 'my_site.conf.erb'
      action :enable
    end

    nginx_site "default" do
      name 'default'
      action :disable
    end


service 'nginx' do
  action [ :enable, :start ]
end

# Replace line
ruby_block "replace_line_nginx" do
  block do
    file = Chef::Util::FileEdit.new("/etc/nginx/nginx.conf")
    file.search_file_replace_line("# server_tokens off;", "     server_tokens off;")
    file.write_file
  end
#  not_if "/bin/grep '^#ignoreip = 127.0.0.1/8' /etc/fail2ban/jail.conf"
  notifies :restart, "service[nginx]"
end

# Make sure the site directory exists
directory '/var/www/my_site' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

cookbook_file '/var/www/my_site/index.html' do
  source 'index.html'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[nginx]"
end
