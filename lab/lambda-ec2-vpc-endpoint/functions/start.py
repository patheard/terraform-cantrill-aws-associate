import boto3
import os
import json

region = 'us-east-1'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    instance=[ event["detail"]["instance-id"] ]    

    print("Starting " + str(instance))
    ec2.start_instances(InstanceIds=instance)
    print("Started instance: " + str(instance))