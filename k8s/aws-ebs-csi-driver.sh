helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --set serviceAccount.controller.create=true \
  --set serviceAccount.controller.name=ebs-csi-controller-sa
 
kubectl annotate serviceaccount ebs-csi-controller-sa \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::<account-id>:role/bricsbiEksEbsCsiDriverRole


### Remove all aws-secret session, as no secret exists and update all OIDC variables.
kubectl edit deployment ebs-csi-controller -n kube-system

aws eks describe-cluster --name brics-bi-k8s --query "cluster.identity.oidc.issuer" --output text --profile apps-k8s-dev

eksctl utils associate-iam-oidc-provider \
  --region eu-west-2 \
  --cluster brics-bi-k8s \
  --approve \
  --profile apps-k8s-dev

aws iam get-role --role-name bricsbiEksEbsCsiDriverRole --query "Role.AssumeRolePolicyDocument" --profile apps-k8s-dev

# Get OIDC Issuer URL
aws eks describe-cluster --name brics-bi-k8s --query "cluster.identity.oidc.issuer" --output text --profile apps-k8s-dev
