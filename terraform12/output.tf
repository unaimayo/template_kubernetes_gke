locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate}
    server: https://${google_container_cluster.gke_cluster.endpoint}
  name: ${google_container_cluster.gke_cluster.name}
contexts:
- context:
    cluster: ${google_container_cluster.gke_cluster.name}
    user: ${google_container_cluster.gke_cluster.name}
  name: ${google_container_cluster.gke_cluster.name}
current-context: ${google_container_cluster.gke_cluster.name}
kind: Config
preferences: {}
users:
- name: ${google_container_cluster.gke_cluster.name}
  user:
    auth-provider:
      config:
        cmd-args: config config-helper --format=json
        cmd-path: gcloud
        expiry-key: '{.credential.token_expiry}'
        token-key: '{.credential.access_token}'
      name: gcp
KUBECONFIG

}

output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "cluster_config" {
  value = base64encode(local.kubeconfig)
}

output "cluster_certificate_authority" {
  value = base64encode(
    google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}

output "cluster_zone" {
  value = var.zone
}

