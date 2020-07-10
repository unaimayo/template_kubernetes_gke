variable "cluster_name" {
  description = "Name of the GKE cluster"
}

variable "zone" {
  description = "Zone in which to create the cluster."
}

variable "kube_version" {
  description = "Kubernetes version for the cluster."
}

variable "machine_type" {
  description = "Machine type for worker nodes."
}

variable "disk_size_gb" {
  description = "Size of the worker node disk"
}

variable "disk_type" {
  description = "Type of the worker node disk"
}

variable "initial_worker_count" {
  description = "Initial number of worker nodes"
}

variable "min_worker_count" {
  description = "Minimum number of worker nodes"
}

variable "max_worker_count" {
  description = "Maximum number of worker nodes"
}

