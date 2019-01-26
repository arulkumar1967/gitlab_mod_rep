resource "google_dns_managed_zone" "test" {
  count = "${var.dns_zone != "no_dns" ? 1 : 0}"
  name     = "${var.dns_zone}"
  dns_name = "${var.dns_name}."
  description = "Example Dev DNS Managed Zone"
}

resource "google_dns_record_set" "gitlab_instance" {
    count = "${var.dns_zone != "no_dns" ? 1 : 0}"
    name = "${var.dns_name}."
    type = "A"
    ttl = 300
    # TODO: This is really hard to read. I'd like to revisit at some point to clean it up.
    # But we shouldn't need two variables to specify DNS name
    managed_zone = "${google_dns_managed_zone.test.name}"
    rrdatas = ["${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"]
}
