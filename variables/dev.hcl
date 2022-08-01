locals {
  environment = "dev"
  
  auth_database_name = "dabserviceauthdb"
    
  

  database_users = [
    "dabserviceauthdb_user",
    "dabserviceprovisioningdb",
    "dabservicetransactiondb_user",
    "dabservicetransactionsdb_user",
    "portalbackend-v2",
    "ocpi-user",
    "evcharginguser",
    "evcharging-be-user",
    "wowbackend",
    "uambackend",
    "dabservicemcpdb_user",
    "postgres_wow",
    "wow-webapp"
    ]
  vpc_id = "vpc-0f62b3731aca37d72"
  db_subnet_group_name = "staging"
  private_subnets_cidr_blocks = "10.1.76.0/22"

}


