# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
  config.vm.define "dbserver" do | dbserver |
    dbserver.vm.network "private_network", ip: "192.168.1.20", virtualbox__intnet: "fithealthnetwork"
    dbserver.vm.provider "virtualbox" do | vb |
      vb.name = "dbserver"
      vb.memory = 2048
      vb.cpus = 2
    end    
    dbserver.vm.provision "copy shellscripts", type: "file", source: "src/main/sh/expect-mysql-secure-install.sh", destination: "/tmp/"
    dbserver.vm.provision "copy add user sqlscript", type: "file", source: "src/main/db/add-user.sql", destination: "/tmp/"
    dbserver.vm.provision "copy dbschema sqlscript", type: "file", source: "src/main/db/db-schema.sql", destination: "/tmp/"
    dbserver.vm.provision "mysql server installation", type: "shell", path: "src/main/sh/install-mysql.sh"
    dbserver.vm.provision "configure remote mysql access", type: "shell", path: "src/main/sh/configure-remote-mysqlaccess.sh"
  end    
  config.vm.define "javaserver" do | javaserver |
    javaserver.vm.network "private_network", ip: "192.168.1.21", virtualbox__intnet: "fithealthnetwork"
    javaserver.vm.network "forwarded_port", host: 80, guest: 8080
    javaserver.vm.provider "virtualbox" do | vb |
      vb.name = "javaserver"
      vb.memory = 2048
      vb.cpus = 2
    end
    javaserver.vm.provision "copy tomcat service config", type: "file", source: "src/main/config/tomcat.service.conf", destination: "/tmp/", run: "always"
    javaserver.vm.provision "copy war", type: "file", source: "target/fithealth2.war", destination: "/tmp/", run: "always"
    javaserver.vm.provision "setupwebserver", type: "shell", path: "src/main/sh/setupwebserver.sh"
    javaserver.vm.provision "deploy application", type: "shell", path: "src/main/sh/deploywar.sh", run: "always"
  end    
end
