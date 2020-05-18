////////////////////////////////
// AWS Connection

aws_region="us-west-2"

aws_profile="solutions-architects"

aws_credentials_file="~/.aws/credentials"

aws_key_pair_name = "jvogt-sa-aws"

aws_key_pair_file = "~/Desktop/jvogt-sa-aws.pem"

////////////////////////////////
// Object Tags

tag_customer="jvogt-habichefdemo"

tag_project="habichef_demo"

tag_name="Jeff Vogt"

tag_dept="SA"

tag_contact="jvogt@chef.io"

tag_application="habichef"

////////////////////////////////
// Automate Config

automate_hostname="a2.chef.jv.run"

automate_license = "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU0ZTUwMjNjLTBhMTAtNGVhZC1iZWY2LTM3ZjFiNmUzNDVmNSIsInZlcnNpb24iOiIxIiwidHlwZSI6ImludGVybmFsIiwiZ2VuZXJhdG9yIjoiY2hlZi9saWNlbnNlLTIuMC4wIiwia2V5X3NoYTI1NiI6ImUwZGYyOGM4YmM2ODE1MGVkYmZlZjk4Y2Q2YjdkYzQzOWMxZjgwYzdlN2VmNzQ3ODkzYTY4OTNhMmY3YjYwZjciLCJnZW5lcmF0aW9uX2RhdGUiOnsic2Vjb25kcyI6MTUzNzc2Mjg1Nn0sImN1c3RvbWVyIjoiSmVmZiBWb2d0IiwiY3VzdG9tZXJfaWQiOiI2MjRBNDc2My0xRDlCLTQ4RjQtODhBMS1GRkZGRTdGRjE0RDUiLCJjdXN0b21lcl9pZF92ZXJzaW9uIjoiMSIsImVudGl0bGVtZW50cyI6W3sibmFtZSI6IkNoZWYgQXV0b21hdGUiLCJtZWFzdXJlIjoibm9kZXMiLCJzdGFydCI6eyJzZWNvbmRzIjoxNTM3NzQ3MjAwfSwiZW5kIjp7InNlY29uZHMiOjE1Nzc4MzY3OTl9fV19.AOLENr-8tCwDUKKlU9SyywfpnTQkN1Et6O8bNnecrG34xxva6SoLEr98TcAQrzWPsB6iwBGjIcu-QxixDob84XkHACs-jwxQJYetw4AYDHsXz_j20APCYK3I__gJLwSn2Iuab_WRVFngNMViLRexV6HM2yE5l7jpt6g1zqBl5T1hu4_g"

automate_alb_acm_matcher = "*.chef.jv.run"
automate_alb_r53_matcher = "chef.jv.run."
