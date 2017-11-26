#!/usr/bin/python

""" 
This program is to control ec2 instances using boto3

"""

import  boto3
# ec2 = boto3.resource('ec2')
# filters =[{'Name':'tag:Name','Values':['Ubuntu-0']}]
# ub0 = list(ec2.instances.filter(Filters=filters))[0]
# print(ub0.ec2.InstanceId)
def findinstanceid(tagkey, tagvalue):
    ec2client = boto3.client('ec2')
    response = ec2client.describe_instances(
                Filters =[
                {
                    'Name':'tag:'+tagkey,
                    'Values':[tagvalue]
                }
            ]
    
    
    )

    instancelist = []
    for reservation in (response["Reservations"]):
        for instance in reservation["Instances"]:
            instancelist.append(instance["InstanceId"])
    print(instancelist[0])
findinstanceid('Name', 'Ubuntu-0')

