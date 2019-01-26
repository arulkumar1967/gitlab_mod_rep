provider "google" {
    credentials = "${file("${var.auth_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

