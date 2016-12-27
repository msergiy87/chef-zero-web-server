Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-14.04"

  config.vm.provider "virtualbox" do |vb|
    # Name used in Oracle VM VirtualBox Manager GUI
    vb.name = "chef-zero-web-server"

    # Customize the amount of memory on the VM (in MB):
    vb.memory = "1024"
  end

  config.vm.network :forwarded_port, guest: 80, host: 4567

  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.nodes_path = "nodes"
    chef.roles_path = "roles"

    chef.add_role "web-server-apache2"
#    chef.add_role "web-server-nginx"
  end
end
