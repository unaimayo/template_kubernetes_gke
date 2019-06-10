# Managed Kubernetes Service within Google Cloud
Copyright IBM Corp. 2019, 2019 \
This code is released under the Apache 2.0 License.

## Overview
This terraform template deploys a kubernetes cluster within Google Cloud's Kubernetes Engine (GKE) service.\

Via this template, a configurable number of worker nodes can be deployed, with autoscaling capabilities provided by the GKE service.

## Prerequisites
* The user must be assigned either the 'GKE Admin' or 'GKE Developer' role to deploy this template within Google Cloud

## Template input parameters

| Parameter name         | Parameter description |
| :---                   | :---        |
| cluster_name           | Name of the GKE cluster |
| zone                   | Zone within the cloud in which to create the cluster |
| kube_version           | Kubernetes version for the cluster. Specify 'latest' for the most recent kubernetes version supported by the Kubernetes Service, or a version number in the X.Y[.Z] format (e.g. 1.13 or 1.13.5).  The most recent maintenance release for the specified version will be selected. |
| machine_type           | Machine type for worker nodes |
| disk\_size\_gb         | Size of the worker node disk |
| disk_type              | Type of the worker node disk |
| initial\_worker\_count | Initial number of worker nodes |
| min\_worker\_count     | Minimum number of worker nodes |
| max\_worker\_count     | Maximum number of worker nodes |
