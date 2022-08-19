import os
import json

cmd = ''' 
	rm -f privKey.pem;
	terraform output -raw private_key > privKey.pem;
	chmod 400 privKey.pem;
      '''
os.popen(cmd)
print("Saved private_key into privKey.pem file")

tf_json = json.loads(os.popen('terraform  output -json').read())

ec2_dns = tf_json["ec2_dns"]["value"]
dynamodb_table =  tf_json["dynamodb_table"]["value"]
aws_region = tf_json["aws_region"]["value"]


cmd = f'\n#SSH \nssh -i "privKey.pem" ec2-user@{ec2_dns}'
print(cmd)
cmd = '#PUT-ITEM\n aws dynamodb put-item --table-name '+dynamodb_table+' --item \'{"testDevopsHash": {"S":"SomeRandomText"}, "someColumn": {"N":"1234"}}\' --region '+aws_region  
print(cmd)
cmd = '#GET-ITEM\n aws dynamodb get-item --table-name '+dynamodb_table+' --key \'{"testDevopsHash": {"S": "SomeRandomText"}}\' --region '+aws_region
print(cmd)
