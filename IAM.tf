
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

resource "aws_iam_policy" "S3_access" {
  name        = "S3_access"
  policy      = "${file("policies/bucketaccess.json")}"
  description = "Allows S3 writing."
}

resource "aws_iam_instance_profile" "bucket_access" {
  name = "s3_access_profile"
  role = aws_iam_role.ansible_role.name
}

resource "aws_iam_policy_attachment" "S3_access" {
  name       = "S3-access"
  roles      = ["${aws_iam_role.ansible_role.name}"]
  policy_arn = "${aws_iam_policy.S3_access.arn}"
}

