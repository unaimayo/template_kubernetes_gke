# Use regular expression to validate format of given kubernetes version
resource "null_resource" "validate-kube-version" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
regex="^latest|(([0-9]+\\.?){0,2}([0-9]+))$"
if [[ ! ${lower(var.kube_version)} =~ $$regex ]]; then
    echo "Invalid kubernetes version"
    exit 1
fi
EOT
  }
}
data "google_container_engine_versions" "k8sversions" {
  location       = "${var.zone}"
  version_prefix = "${lower(var.kube_version) != "latest" ? var.kube_version : ""}"
}

locals {
  # Supported versions ordered latest to earliest
  supported_versions = "${data.google_container_engine_versions.k8sversions.valid_master_versions}"
  version_count      = "${length(local.supported_versions)}"
  requested_version  = "${local.version_count > 0 ?
                          local.supported_versions[0] :
                          data.google_container_engine_versions.k8sversions.latest_master_version}"
}

resource "google_container_cluster" "gke_cluster" {
  depends_on = ["null_resource.validate-kube-version"]
  name     = "${var.cluster_name}"
  location = "${var.zone}"
  min_master_version = "${local.requested_version}"
  remove_default_node_pool = true

  initial_node_count = "${var.initial_worker_count}"

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "gke_cluster_pool" {
  name       = "${var.cluster_name}-pool"
  location   = "${var.zone}"
  cluster    = "${google_container_cluster.gke_cluster.name}"
  node_count = "${var.initial_worker_count}"
  version    = "${local.requested_version}"

  autoscaling {
    min_node_count = "${var.min_worker_count}"
    max_node_count = "${var.max_worker_count}"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    disk_size_gb = "${var.disk_size_gb}"
    disk_type    = "${var.disk_type}"

    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
  
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
