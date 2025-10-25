aws_region       = "us-east-1"
project_name     = "R-costa-sol"
environment      = "dev"
vpc_cidr         = "10.0.0.0/16"

# RDS - BD
db_name            = "hoteldb"
db_username        = "admin"
db_password        = "C12on45t@"
db_instance_class  = "db.t3.micro"

# EC2 - Sistema Backend
backend_image      = "983753079262.dkr.ecr.us-east-1.amazonaws.com/hotel-backend:latest"
instance_type      = "t3.small"
min_instances      = 2
max_instances      = 6
desired_instances  = 2