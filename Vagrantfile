# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "kdc" do |kdc|
    kdc.vm.box = "ubuntu/xenial64"
    kdc.vm.hostname = "kdc.example.com"
    kdc.vm.network :forwarded_port, host: 8888, guest: 88, protocol: 'udp'
    kdc.vm.network :forwarded_port, host: 8888, guest: 88, protocol: 'tcp'
    kdc.vm.network :forwarded_port, host: 8749, guest: 8749
    kdc.vm.network :forwarded_port, host: 1389, guest: 389
    kdc.vm.network :forwarded_port, host: 1636, guest: 636
    kdc.vm.network "private_network", ip: "192.168.10.21"
    kdc.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "2"
      vb.memory = "2048"
    end
    kdc.vm.provision "shell", path: "hostes.sh"
    kdc.vm.provision "shell", path: "MasterKDCServer/ldap.sh"
    kdc.vm.provision "shell", path: "MasterKDCServer/kerberos.sh"
  end

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/xenial64"
    server.vm.hostname = "server.example.com"
    server.vm.network :forwarded_port, host: 8080, guest: 8080
    server.vm.network :forwarded_port, host: 8440, guest: 8440
    server.vm.network :forwarded_port, host: 8441, guest: 8441
    server.vm.network "private_network", ip: "192.168.10.22"
    server.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "2"
      vb.memory = "2048"
    end
    server.vm.provision "shell", path: "hostes.sh"
    server.vm.provision "shell", path: "KerberosServer/ambari-server.sh"
  end

  config.vm.define "hdp" do |hdp|
    hdp.vm.box = "bento/ubuntu-16.04"
    hdp.vm.hostname = "hdp.example.com"
    hdp.vm.network :forwarded_port, host: 8670, guest: 8670
    hdp.vm.network "private_network", ip: "192.168.10.23"
    hdp.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "4"
      vb.memory = "16000"
    end
    hdp.vm.provision "shell", path: "hostes.sh"
    hdp.vm.provision "shell", path: "KerberosServer/server.sh"
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/xenial64"
    client.vm.hostname = "client.example.com"
    client.vm.network "private_network", ip: "192.168.10.24"
    client.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "2"
      vb.memory = "2048"
    end
    client.vm.provision "shell", path: "hostes.sh"
    client.vm.provision "shell", path: "KerberosClient/client.sh"
  end

end
