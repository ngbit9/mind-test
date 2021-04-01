data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_subnetwork" "subnet" {
  name    = var.subnet
  project = var.project_id
  region  = var.region
}

data "google_service_account" "mindvalley_gke" {
  account_id = "mv-stg-applications-hub-gke-sa"
  project    = var.project_id
}

  module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version                 = "14.0.1"
  name                    = var.cluster_name
  project_id              = var.project_id
  region                  = var.region
  network                 = var.network
  subnetwork              = var.subnet
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  enable_private_endpoint = false
  master_ipv4_cidr_block    = "10.140.16.0/28"
  default_max_pods_per_node = 50
 

  node_pools = [
    {
      name               = "platform-normal-1"
      min_count          = 1
      max_count          = 2
      node_locations     = "us-east4-b,us-east4-c"
      local_ssd_count    = 0
      machine_type       = "n2-standard-2"
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.mindvalley_gke.email
      preemptible        = false
      max_pods_per_node  = 12
      initial_node_count = 0
    },
    {
      name               = "platform-premp-1"
      min_count          = 2
      max_count          = 4
      local_ssd_count    = 0
      machine_type       = "n2-standard-2"
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.mindvalley_gke.email
      preemptible        = true
      max_pods_per_node  = 12
      initial_node_count = 0
    },

    {
      name               = "generics-normal-1"
      min_count          = 1
      max_count          = 2
      node_locations     = "us-east4-b,us-east4-c"
      local_ssd_count    = 0
      machine_type       = "n2-standard-2"
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.mindvalley_gke.email
      preemptible        = false
      max_pods_per_node  = 12
      initial_node_count = 1
    },

    {
      name               = "generics-premp-1"
      min_count          = 2
      max_count          = 4
      local_ssd_count    = 0
      machine_type       = "n2-standard-2"
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = data.google_service_account.mindvalley_gke.email
      preemptible        = true
      max_pods_per_node  = 12
      initial_node_count = 0
    },
  ]

  node_pools_labels = {
    all = {
      environment = "production"
      namespace   = "default"
    }
  }

node_pools_tags = {
    all = []

    generics-normal-1 = [
      "generics-node-pools",
    ]

    generics-premp-1 = [
      "generics-node-pools",
    ]

    platform-normal-1 = [
      "platform-node-pools",
    ]

    platform-premp-1 = [
      "platform-node-pools",
    ]

  }

  node_pools_taints = {
    all = []
    generics-normal-1 = [
      {
        key    = "generics"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    generics-premp-1 = [
      {
        key    = "generics"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    platform-normal-1 = [
      {
        key    = "platform"
        value  = true
        effect = "NO_SCHEDULE"
      },
    ]

    platform-premp-1 = [
      {
        key    = "platform"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }


  master_authorized_networks = [
    {
      cidr_block   = var.subnet_cidr
      display_name = "VPC"
    },

    {
      cidr_block   = "35.235.240.0/20"
      display_name = "IAP-range"
    },
   
   {
      cidr_block   = "${module.bastion.ip_address}/32"
      display_name = "bastion-server-ip"
    },

  ]
}

