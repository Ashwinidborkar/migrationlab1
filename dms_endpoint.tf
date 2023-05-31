# # Create an endpoint for the source database

# resource "aws_dms_endpoint" "source" {
#   database_name = "${var.source_db_name}"
#   endpoint_id   = "${var.stack_name}-dms-${var.environment}-source"
#   endpoint_type = "source"
#   engine_name   = "mysql"
#   password      = ""
#   port          = "3306"
#   server_name   = "mysql"
#   ssl_mode      = "none"
#   username      = ""

#   tags {
#     Name        = "Source-endopint"
#   }
# }

# # Create an endpoint for the target database

# resource "aws_dms_endpoint" "target" {
#   database_name = "${var.target_db_name}"
#   endpoint_id   = "${var.stack_name}-dms-${var.environment}-target"
#   endpoint_type = "target"
#   engine_name   = "${var.target_engine}"
#   password      = "${var.target_password}"
#   port          = "${var.target_db_port}"
#   server_name   = "${aws_db_instance.target.address}"
#   ssl_mode      = "none"
#   username      = "${var.target_username}"

#   tags {
#     Name        = "Target-endpoint"
    
#   }
# }