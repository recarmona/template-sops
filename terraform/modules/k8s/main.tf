# After the cluster is setup, this script will retrieve the Kubeconfig
# file from S3 storage and merge in the local ~/.kube/config

# Retrieves kubeconfig
resource "null_resource" "kubeconfig" {
  triggers = {
    kubeconfig_path = var.kubeconfig_path
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOF
      # Get kubeconfig from storage
      aws s3 cp ${var.kubeconfig_path} ~/.kube/new

      # Merge new config into existing
      export KUBECONFIGBAK=$KUBECONFIG
      export KUBECONFIG=~/.kube/new:~/.kube/config
      # Do not redirect to ~/.kube/config or you may truncate the results
      kubectl config view --flatten > ~/.kube/merged
      mv -f ~/.kube/merged ~/.kube/config

      # Cleanup
      rm -f ~/.kube/new
      export KUBECONFIG=$KUBECONFIGBAK
      unset KUBECONFIGBAK
    EOF
  }
}