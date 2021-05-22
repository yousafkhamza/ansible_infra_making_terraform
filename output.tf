output "ansible-master" {
        value = aws_instance.master.public_ip
}