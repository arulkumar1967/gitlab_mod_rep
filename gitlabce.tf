resource "google_service_account" "gitlab-ce" {
    account_id   = "gitlab-ce"
    display_name = "gitlab-ce"
}

resource "google_compute_instance" "gitlab-ce" {
    count = "${var.deploy_gitlab ? 1 : 0}"
    name = "${var.prefix}${var.instance_name}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"

    tags = ["gitlab"]

    connection {
        type = "ssh"
        user = "ubuntu"
        agent = "false"
        private_key = "${file("${var.ssh_key}")}"
    }

    boot_disk {
        initialize_params {
            image = "${var.image}"
          }
    }

    attached_disk {
        source = "${var.data_volume}"            
        device_name = "gitlab_data"
    }

    network_interface {
        network = "${var.network}"
        access_config {
            nat_ip = "${google_compute_address.external_ip.address}"
        }
    }

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }

    service_account {       
        email = "${google_service_account.gitlab-ce.email}"
        scopes = ["cloud-platform"]
    }

    provisioner "file" {
        content = "${data.template_file.gitlab.rendered}"
        destination = "/tmp/gitlab.rb.append"
    }

    provisioner "file" {
        source = "${path.module}/templates/gitlab.rb.append"
        destination = "/tmp/gitlab.rb"
    }

    provisioner "file" {
        source = "${path.module}/bootstrap"
        destination = "/tmp/bootstrap"
    }

    provisioner "file" {
        source = "${var.ssl_key}"
        destination = "/tmp/ssl_key"
    }

    provisioner "file" {
        source = "${var.ssl_certificate}"
        destination = "/tmp/ssl_certificate"
    }

    provisioner "remote-exec" {
        inline = [
            "cat /tmp/gitlab.rb.append >> /tmp/gitlab.rb",
            "chmod +x /tmp/bootstrap",
            "sudo /tmp/bootstrap ${var.dns_name}"
        ]
    }
}
