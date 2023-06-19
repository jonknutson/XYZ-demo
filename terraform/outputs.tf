output "ecr_repo" {
  value = {
    repository_name = aws_ecr_repository.xyz_demo.name
    arn             = aws_ecr_repository.xyz_demo.arn
    registry_id     = aws_ecr_repository.xyz_demo.registry_id
    repository_url  = aws_ecr_repository.xyz_demo.repository_url
  }
  description = "The ECR repository for storing xyzdemo container images."
}

output "eks_cluster" {
  value = {
    cluster_name         = module.eks-cluster.cluster_name
    cluster_endpoint     = module.eks-cluster.cluster_endpoint
    cluster_oidc_provier = module.eks-cluster.oidc_provider_arn
  }
}