/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                 = "terraform-google-modules/network/google//modules/vpc"
  version                                = "3.2.0"
  network_name                           = var.network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  routing_mode                           = var.routing_mode
  project_id                             = var.project_id
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  mtu                                    = var.mtu
}

/******************************************
	Subnet configuration
 *****************************************/
module "subnets" {
  source           = "terraform-google-modules/network/google//modules/subnets"
  version          = "3.2.0"
  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
}

/******************************************
	Routes
 *****************************************/
module "routes" {
  source       = "terraform-google-modules/network/google//modules/routes"
  version      = "3.2.0"
  project_id   = var.project_id
  network_name = module.vpc.network_name
  routes       = var.routes
  depends_on   = [module.subnets]
}

module "cloud_router" {
  source     = "terraform-google-modules/cloud-router/google"
  version    = "~> 0.4"
  name       = var.cloud_router_name
  project    = var.project_id
  network    = var.network_name
  region     = var.region
  depends_on = [module.subnets]

  nats = [{
    name = "mv-stg-applications-hub-cloud-nat"
  }]
}
