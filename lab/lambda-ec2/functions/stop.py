import boto3
import os
import json

region = "us-east-1"
ec2 = boto3.client("ec2", region_name=region)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    instance=[ event["detail"]["instance-id"] ]    

    print("Stopping " + str(instance))
    ec2.stop_instances(InstanceIds=instance)
    print("Stopped instance: " + str(instance))