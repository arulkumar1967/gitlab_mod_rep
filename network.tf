resource "google_compute_network" "gitlab_network" {
    count = "${var.network != "default" ? 1 : 0}"
    description = "Network for GitLab instance"
    name = "${var.network}"
    auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "external_ports_ssl" {
    count = "${var.ssl_certificate != "/dev/null" ? var.deploy_gitlab ? 1 : 0 : 0}"
    name = "${var.prefix}${var.external_ports_name}"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports = "${var.public_ports_ssl}"
    }
}

resource "google_compute_firewall" "external_ports_no_ssl" {
    count = "${var.ssl_certificate != "/dev/null" ? 0 : var.deploy_gitlab ? 1 : 0}"
    name = "${var.prefix}${var.external_ports_name}"
    network = "${var.network}"

    allow {
        protocol = "tcp"
        ports = "${var.public_ports_no_ssl}"
    }
}

resource "google_compute_address" "external_ip" {
    count = "${var.deploy_gitlab ? 1 : 0}"
    name = "${var.prefix}gitlab-external-address"
    region = "${var.region}"
}




