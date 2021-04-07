project_id = "searce-playground"
network_name = "vpc-us-east4"
region = "us-central1"
cloud_router_name = "mv-stg-applications-hub-router"
subnets = [
  {
    subnet_name           = "subnet-us-east4-01"
    subnet_ip             = "10.13.0.0/20"
    subnet_region         = "us-central1"
    subnet_private_access = "true"
    subnet_flow_logs      = "false"
  }
]

secondary_ranges = {
        subnet-us-central1-01-01 = [
            {
                range_name    = "pods-subnet"
                ip_cidr_range = "10.141.0.0/20"
            },

            {
                range_name    = "svc-subnet"
                ip_cidr_range = "10.142.0.0/20"
            }

        ]
    }

