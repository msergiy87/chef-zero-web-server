#
# Cookbook Name:: my_apache2_app
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

    web_app "my_site" do
      server_name node['hostname']
      server_aliases [node['fqdn'], "my-site.example.com"]
      docroot "/var/www/my_site"
      cookbook 'apache2'
    end


# Add line
ruby_block "insert_line_apache" do
  block do
    file = Chef::Util::FileEdit.new("/etc/apache2/apache2.conf")
    file.insert_line_if_no_match("^ServerTokens ProductOnly", "ServerTokens ProductOnly")
    file.insert_line_if_no_match("^ServerSignature Off", "ServerSignature Off")
    file.write_file
  end
  not_if "/bin/grep '^ServerSignature Off' /etc/apache2/apache2.conf"
  notifies :restart, "service[apache2]"
end

# Make sure the site directory exists
directory '/var/www/my_site' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/var/www/my_site/index.html' do
  source 'index.html'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[apache2]"
end
