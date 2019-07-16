Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |v|
    v.memory = 512
  end

  config.vm.define "registry" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.hostname = "registry"
    db.vm.network :private_network, ip: "10.10.10.10"

    db.vm.provision "ansible" do |ansible|
      ansible.config_file = "ansible/ansible.cfg"
      # ansible.galaxy_roles_path = "ansible/roles/"
      ansible.playbook = "ansible/playbooks/site.yml"
      ansible.groups = {
        "tag_registry" => ["registry"],
        "tag_reddit-db:vars" => {}
      }
    end
  end

  config.vm.define "docker-host" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.hostname = "docker-host"
    app.vm.network :private_network, ip: "10.10.10.20"

    app.vm.provision "ansible" do |ansible|
      ansible.config_file = "ansible/ansible.cfg"
      # ansible.galaxy_roles_path = "ansible/roles/"
      ansible.playbook = "ansible/playbooks/site.yml"
      ansible.groups = {
        "tag_docker-host" => ["docker-host"],
        "tag_docker-host:vars" => {}
      }
      ansible.extra_vars = {
        "deploy_user" => "vagrant"
      }
    end
  end
end

