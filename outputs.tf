 output "address" {
     value = "${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"
 }

 output "gitlab-ce_email" {
     value =  "${google_service_account.gitlab-ce.email}"
 }

 output "gitlab-ci-runner_email" {
     value =  "${google_service_account.gitlab-ci-runner.email}"
 }

#output "runner_host" {
#    value = "${data.template_file.runner_host.rendered}"
#}
