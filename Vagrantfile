# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "krbldap.example.com"
  config.vm.network :forwarded_port, host: 8888, guest: 88, protocol: 'udp'
  config.vm.network :forwarded_port, host: 8888, guest: 88, protocol: 'tcp'
  config.vm.network :forwarded_port, host: 8749, guest: 8749
  config.vm.network :forwarded_port, host: 1389, guest: 389
  config.vm.network :forwarded_port, host: 1636, guest: 636

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.cpus = "2"
    vb.memory = "2048"
  end

#  config.vm.provision "shell", inline: "hostname krbldap.example.com"
  config.vm.provision "shell", path: "ldap.sh"
  config.vm.provision "shell", path: "kerberos.sh"
end
