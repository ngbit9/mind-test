locals {
  bastion_name = format("%s-bastion", var.cluster_name)
  bastion_zone = format("%s-a", var.region)
  }
module "bastion" {
  source         = "terraform-google-modules/bastion-host/google"
  version        = "3.1.0"
  network        =  var.network
  subnet         = "projects/mv-prod-applications-hub/regions/us-east4/subnetworks/subnet-us-east4-01-01"
  project        = var.project_id
  host_project   = ""
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  image_family   = "debian-9"
  machine_type   = "g1-small"
  shielded_vm    = "false"
}
