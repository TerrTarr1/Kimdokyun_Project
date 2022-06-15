vim user.tf

resource "aws_key_pair" "Test_EC2_key" {
  key_name = "TF_Test_Key"
  public_key = file("./testPubkey.pub")
}

data "template_file" "Test_User_Data" {
  template = file("Test_Web.sh")
}

:wq
tf plan
tf apply
