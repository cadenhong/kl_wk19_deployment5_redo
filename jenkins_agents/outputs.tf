output "tf_instance_ip" {
  value = aws_instance.tf_agent.public_ip
}

output "docker_instance_ip" {
  value = aws_instance.docker_agent.public_ip
}