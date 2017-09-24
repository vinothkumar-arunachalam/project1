resource "virtualbox_vm" "node" {
    count = 2
name = "${format("node-%02d", count.index+1)}"
url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1602_01.VirtualBox.box"
    image = "./CentOS-7-x86_64-Vagrant-1602_01.VirtualBox.box"
    cpus = 2
    memory = "512mib"


    network_adapter {
        type = "bridged"
        host_interface = "en0"
    }

 provisioner "local-exec" {
    command = "sleep 30 && echo -e \"[webserver]\n${virtualbox_vm.node.web.ipv4_address} ansible_connection=ssh ansible_ssh_user=root ansible_shh_pass=root\" > inventory &&  ansible-playbook -i inventory oc-playbook.yml"

  }

}
provisioner "file" {
    source      = "hosts"
    destination = "/etc"
  }
output "IPAddr" {
    value = "${element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 1)}"
}
output "IPAddr_2" {
    value = "${element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 2)}"
}
