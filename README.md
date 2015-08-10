### Docker Private Registry, with UI, Jenkins and Apt-Cacher NG

Running inside a Vagrant/VirtualBox VM and configured by Puppet

Requirements:

* Vagrant - http://www.vagrantup.com/downloads.html
* VirtualBox - https://www.virtualbox.org/wiki/Downloads

Optional:

* Vagrant Hosts Updater Plugin - https://github.com/cogitatio/vagrant-hostsupdater

Usage:

After installing the requirements, cd into the vagrant/registry-vm directory and run the following command:

`git submodule update --init --recursive`

`vagrant up`

The VM will be spun up and the docker containers provisioned by Puppet. This process will take several minutes.

When it finishes, navigate to [http://localhost:8100](http://localhost:8100) to verify that the registry is alive.

Information on the Docker registry can be found here:

https://docs.docker.com/registry/deploying/

To access to UI, navigate to [http://localhost:8100/ui](http://localhost:8100/ui)

To access Jenkins, navigate to [http://localhost:8100/jenkins](http://localhost:8100/jenkins)