Vagrant.configure("2") do |config|
		config.vm.box = "ubuntu/xenial64"
		config.vm.provision :shell, :inline => "ulimit -n 4048"
		config.vm.boot_timeout = 3600
		config.vm.network "public_network" , ip: "192.168.1.169"

  	config.vm.define :gpdbsne do |gpdbsne_config|
		gpdbsne_config.vm.provider :virtualbox do |v3|
			v3.customize ["modifyvm", :id, "--memory", "4096"]
    	end
		gpdbsne_config.vm.network :private_network, ip: "172.16.1.11"
		gpdbsne_config.vm.network "forwarded_port", guest: 5432, host: 5433
		gpdbsne_config.vm.hostname = "gpdbsne"
		gpdbsne_config.vm.provision :shell, :inline => "sudo mkdir -p /opt/configs"
		gpdbsne_config.vm.provision :shell, :inline => "sudo chown -R vagrant /opt/configs"
		gpdbsne_config.vm.provision "file", source: "./gpdb/configs", destination: "/opt/configs"
		gpdbsne_config.vm.provision :shell, :path => "setup_machine.sh"
  	end
end
