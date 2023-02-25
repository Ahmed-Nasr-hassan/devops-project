resource "google_compute_instance" "management-vm" {
  name         = var.name # "management-vm"
  machine_type = var.vm_type # "f1-micro"
  zone         = var.vm_zone #"us-central1-a"

  boot_disk {
    initialize_params {
      image = var.vm_image # "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = var.vm_subnet_self_link # google_compute_subnetwork.management-subnet.name 
    access_config {
      
    }
  }

  service_account {
    email  = var.vm_service_account # google_service_account.vm-sa.email
    scopes = var.vm_scopes #["container.admin"]
  }

  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      echo '[management-vm]' > ../ansible/inventory.ini
      echo ${google_compute_instance.management-vm.network_interface.0.access_config.0.nat_ip} >> ../ansible/inventory.ini 
      sleep 90
      echo > ~/.ssh/known_hosts
      ansible-playbook ../ansible/playbook.yaml -i ../ansible/inventory.ini
    EOF

  }
}