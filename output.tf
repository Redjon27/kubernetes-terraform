output "aws_eks_cluster" {
  description = "Eks name"
  value       = aws_eks_cluster.redi.name
}

output "version" {
  description = "Eks version"
  value       = aws_eks_cluster.redi.version
}

output "node_group_name" {
  description = "EKS Node Group name"
  value       = aws_eks_node_group.private_nodes.node_group_name
}

output "node_group_instance_types" {
  description = "Instance types for the EKS Node Group"
  value       = aws_eks_node_group.private_nodes.instance_types
}

output "node_group_subnet_ids" {
  description = "Subnet IDs for the EKS Node Group"
  value       = aws_eks_node_group.private_nodes.subnet_ids
}

output "node_group_scaling_config" {
  description = "Scaling configuration for the EKS Node Group"
  value = {
    desired_size = aws_eks_node_group.private_nodes.scaling_config[0].desired_size
    max_size     = aws_eks_node_group.private_nodes.scaling_config[0].max_size
    min_size     = aws_eks_node_group.private_nodes.scaling_config[0].min_size
  }
}

output "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks.url
}
