terraform {
  required_version = "~> 1.3.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }
  }
}

locals {
  defaultWebHostnames          = var.domain == null ? null : ["www.${var.domain}", "${var.domain}"]
  defaultApiHostnames          = var.domain == null ? null : ["api.${var.domain}"]
  defaultGrpcHostnames         = var.domain == null ? null : ["grpc.${var.domain}"]

  webHostnames          = var.webHostnames == null ? local.defaultWebHostnames : var.webHostnames
  apiHostnames          = var.apiHostnames == null ? local.defaultApiHostnames : var.apiHostnames
  grpcHostnames         = var.grpcHostnames == null ? local.defaultGrpcHostnames : var.grpcHostnames
}

module "speakeasy_k8s" {
  source                       = "../k8s"
  speakeasyName                = var.speakeasyName
  namespace                    = var.namespace
  webHostnames                 = local.webHostnames
  apiHostnames                 = local.apiHostnames
  grpcHostnames                = local.grpcHostnames
  createK8sPostgres            = var.createK8sPostgres
  postgresDSN                  = var.postgresDSN
  signInURL                    = var.signInURL
  githubClientId               = var.githubClientId
  githubClientSecretName       = var.githubClientSecretName
  githubClientSecretKey        = var.githubClientSecretKey
  githubClientSecretValue      = var.githubClientSecretValue
  githubCallbackURL            = var.githubCallbackURL
  cloudProvider                = "aws"
  ingressNginxEnabled          = var.ingressNginxEnabled
  controllerStaticIpOrHostname = var.controllerHostname
}
