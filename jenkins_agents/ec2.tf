resource "aws_instance" "tf_agent" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_sg
  key_name = var.key_name
  user_data = "${file("setup_tf_agent.sh")}"

  tags = {
    Name = "agent_tf"
  }
}

resource "aws_instance" "docker_agent" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_sg
  key_name = var.key_name
  user_data = "${file("setup_docker_agent.sh")}"

  tags = {
    Name = "agent_docker"
  }
}