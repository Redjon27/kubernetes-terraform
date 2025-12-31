resource "aws_iam_role" "redi" {
  name = "eks-redi-cm"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "redi-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.redi.name
}

resource "aws_eks_cluster" "redi" {
  name     = "redi"
  version  = "1.34"
  role_arn = aws_iam_role.redi.arn

  vpc_config {
    subnet_ids = ["subnet-0ab10e27fa8654d76", "subnet-0947a2eed8564c867"]

    endpoint_private_access = false
    endpoint_public_access = true

  }

  depends_on = [aws_iam_role_policy_attachment.redi-AmazonEKSClusterPolicy]
}
