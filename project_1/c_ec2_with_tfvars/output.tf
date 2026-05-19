output "instance_id" {
  value = aws_instance.ec2_with_tf_vars.id
}

output "instance_public_ip" {
  value = aws_instance.ec2_with_tf_vars.public_ip
}