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
      vb.cpus = "1"
      vb.memory = "2048"
    end
    kdc.vm.provision "shell", path: "MasterKDCServer/ldap.sh"
    kdc.vm.provision "shell", path: "MasterKDCServer/kerberos.sh"
    kdc.vm.provision "shell", path: "hostes.sh"
  end

  config.vm.define "server" do |server|
    server.vm.box = "ubuntu/xenial64"
    server.vm.hostname = "server.example.com"
    server.vm.network :forwarded_port, host: 8080, guest: 8080
    server.vm.network "private_network", ip: "192.168.10.22"
    server.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "2"
      vb.memory = "4096"
    end
    server.vm.provision "shell", path: "hostes.sh"
    server.vm.provision "shell", path: "KerberosServer/server.sh"
    server.vm.provision "shell", path: "KerberosServer/jettyServer/createServer.sh"
  end

  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/xenial64"
    client.vm.hostname = "client.example.com"
    client.vm.network "private_network", ip: "192.168.10.23"
    client.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.cpus = "1"
      vb.memory = "2048"
    end
    client.vm.provision "shell", path: "hostes.sh"
    client.vm.provision "shell", path: "KerberosClient/client.sh"
  end

end
