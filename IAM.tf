
##################################### for ansible server ######################################

resource "aws_iam_role" "ansible_role" {
  name               = "ansible_role"
  assume_role_policy  = "${file("policies/assumerolepolicy.json")}"
}

resource "aws_iam_instance_profile" "assume_role_profile" {                             
  name  = "assume_role_profile"                         
  role = "${aws_iam_role.ansible_role.name}"
}

resource "aws_iam_policy" "full_ec2_access_policy" {
  name        = "full_ec2_access_policy"
  description = "for dynamic inventory"
  policy      = "${file("policies/policysfullaccess.json")}"
}

resource "aws_iam_policy_attachment" "aws-ansible" {
  name       = "aws-ansible"
  roles      = ["${aws_iam_role.ansible_role.name}"]
  policy_arn = "${aws_iam_policy.full_ec2_access_policy.arn}"
}
################################### Consul join policy #####################################
resource "aws_iam_role" "consul-join" {
  name               = "opsschool-consul-join"
  assume_role_policy = "${file("policies/assumerolepolicy.json")}"
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "opsschool-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = "${file("policies/describe-instances.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "opsschool-consul-join"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "opsschool-consul-join"
  role = aws_iam_role.consul-join.name
}

######################### Bucket policy ######################
resource "aws_iam_role" "bucket_role" {
  name               = "bucket_role"
  assume_role_policy  = "${file("policies/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "S3_access" {
  name        = "S3_access"
  policy      = "${file("policies/bucketaccess.json")}"
  description = "Allows S3 writing."
}

resource "aws_iam_instance_profile" "bucket_access" {
  name = "s3_access_profile"
  role = aws_iam_role.bucket_role.name
}

resource "aws_iam_policy_attachment" "S3_access" {
  name       = "S3-access"
  roles      = ["${aws_iam_role.bucket_role.name}"]
  policy_arn = "${aws_iam_policy.S3_access.arn}"
}

######################3# EKS full access #################
resource "aws_iam_role" "eks-control" {
  name               = "eks-control"
  assume_role_policy = "${file("policies/assumerolepolicy.json")}"
}

# Create the policy
resource "aws_iam_policy" "eks-control" {
  name        = "eks-control"
  description = "Allows eks control."
  policy      = "${file("policies/eksfullaccess.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "eks-control" {
  name       = "eks-control"
  roles      = [aws_iam_role.ansible_role.name,aws_iam_role.eks-control.name]
  policy_arn = aws_iam_policy.eks-control.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "eks-control" {
  name  = "eks-control"
  role = aws_iam_role.ansible_role.name
}

################## for kandula ##########################################

resource "aws_iam_role" "kandula_role" {
  name               = "kandula_role"
  assume_role_policy  = "${file("policies/assumerolepolicy.json")}"
}

resource "aws_iam_instance_profile" "assume_role_kandula" {                             
  name  = "assume_role_profile"                         
  role = "${aws_iam_role.kandula_role.name}"
}

resource "aws_iam_policy" "kandula_role_access_policy" {
  name        = "kandula_role_access_policy"
  description = "for kandula role"
  policy      = "${file("policies/kandula_access.json")}"
}

resource "aws_iam_policy_attachment" "kandula_role" {
  name       = "kandula_role"
  roles      = ["${aws_iam_role.kandula_role.name}"]
  policy_arn = "${aws_iam_policy.kandula_role_access_policy.arn}"
}

