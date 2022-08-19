# devops-option-05

In order to execute this terraform project is required to configure a local aws profile using:
            aws configure
And then setting the name of the profile on the variables.tf file (line 15)
    variable "tf_profile" {
        default = "default" 
    }


Once done, simply run:

    terraform init

    terraform apply         #carefully review plan 
    
    *test*

    terraform destroy       #carefully review plan

*test*
In order to test the deployment, we can run the python test.py file which will:
1) Export the newly generated SSH Key into a file and grant it permissions
2) Print the cmds for: ssh connection, getting and putting some items into dynamodb. Which can then run manually at will. 
The template for this calls maybe found at the bottom of this document.

Note that it may take a couple of minutes after the apply is performed for all the changes to be made (such as security groups)


No modules were used on the development of the project as the resources were easily handled without them.
Most of the resources have been put into specific .tf files for easier maintenance.

In order to support multiple stages and dynamic names, there are two variables, var.prefix and local.stack (var.env+var.region), that are prepended and appended to all resources names. 

I have decided to apply default_tags (find below) on all resources for easier identification:
    tags = {
        "createdBy:terraform"         = "true"
        "${var.customer}:devops:task" = "5"
        "${var.customer}:env" = var.env
        }

The code has been tested and supports multiple environments on the same region.

TEST TEMPLATE

#handle new ssh

    rm -f privKey.pem;

    terraform output -raw private_key > privKey.pem;

    chmod 400 privKey.pem;

#ssh connection

    ssh -i "privKey.pem" ec2-user@{output.ec2_dns}
#put-item

    aws dynamodb put-item --table-name {output.dynamodb_table} --item '{"testDevopsHash": {"S":"SomeRandomText"}, "someColumn": {"N":"1234"}}' --region {output.aws_region}
#get-item

    aws dynamodb get-item --table-name {output.dynamodb_table} --key '{"testDevopsHash": {"S": "SomeRandomText"}}' --region '{output.aws_region}