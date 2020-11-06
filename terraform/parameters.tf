
data "aws_ssm_parameter" "dbpassword" {
  name = "/database/password"
#   with_decryption = true
}