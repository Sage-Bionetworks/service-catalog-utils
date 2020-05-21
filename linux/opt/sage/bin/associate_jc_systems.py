#!/usr/bin/python

import json
import os
import urllib.request

OIDC_USER_ID = os.environ["OIDC_USER_ID"]
JC_SERVICE_API_KEY = os.environ["JC_SERVICE_API_KEY"]
JC_AGENT_CONFIG_FILE = "/opt/jc/jcagent.conf"
JC_SYSTEM_USER_ENDPOINT = "https://console.jumpcloud.com/api/systemusers?fields=attributes"

def do_get_request(url):
    '''Perform a REST GET request'''
    request = urllib.request.Request(url)
    request.add_header('Accept', 'application/json')
    request.add_header('Content-Type', 'application/json')
    request.add_header('x-api-key', JC_SERVICE_API_KEY)

    try:
        with urllib.request.urlopen(request) as r:
            response = r.read()
    except Exception as e:
        print(e)

    return json.loads(response.decode("utf-8"))

def do_post_request(url, data):
    '''Perform a REST POST request'''
    request = urllib.request.Request(url)
    request.add_header('Accept', 'application/json')
    request.add_header('Content-Type', 'application/json')
    request.add_header('x-api-key', JC_SERVICE_API_KEY)

    try:
        with urllib.request.urlopen(request, data) as r:
            response = r.read()

    except Exception as e:
        print(e)

def get_json_file(path):
    '''Read json file from path'''

    try:
        file = open(path)
        data = json.load(file)
    finally:
        file.close()

    return data

def get_jc_user_id(users):
    '''Get the jumpcloud user id from a list of JC users
        Assumes that the JC user contains a SynapseUserId custom attribute
    '''
    user_id = None
    for user in users:
        attributes = user['attributes']
        for attribute in attributes:
            if attribute['name'] == "SynapseUserId" and attribute['value'] == OIDC_USER_ID:
                user_id = user['_id']

    return user_id

def associate_jc_system():
    '''Associate a provisioned instance with a JC user'''
    jc_users = do_get_request(JC_SYSTEM_USER_ENDPOINT)['results']
    jc_user_id = get_jc_user_id(jc_users)
    print("jc_user_id = " + jc_user_id)

    if (jc_user_id):
        jc_system_key = get_json_file(JC_AGENT_CONFIG_FILE)['systemKey']
        print("jc_system_key = " + jc_system_key)

        url = 'https://console.jumpcloud.com/api/v2/users/' + jc_user_id + '/associations'
        values = {
            "attributes": {
                "sudo": {
                    "enabled": True,
                    "withoutPassword": False
                }
            },
            "op": "add",
            "type": "system",
            "id": jc_system_key
        }
        data = json.dumps(values).encode("utf-8")
        do_post_request(url, data)

if __name__ == "__main__":
    associate_jc_system()