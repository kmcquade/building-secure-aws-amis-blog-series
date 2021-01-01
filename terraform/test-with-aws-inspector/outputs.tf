output "bastion_ip" {
//  value = "${var.internal ? module.ec2_bastion.private_ip : module.ec2_bastion.public_ip}"
  value       = "${module.ec2_bastion.public_ip}"
}