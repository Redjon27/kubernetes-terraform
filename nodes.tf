resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-new"  # Change the role name to a unique name
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_secrets_manager_read_write" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.redi.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn

  subnet_ids = ["subnet-0ab10e27fa8654d76", "subnet-0947a2eed8564c867"]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.nodes_secrets_manager_read_write,
  ]
}
