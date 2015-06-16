#!/usr/bin/python
import argparse
import requests,json
from requests.auth import HTTPBasicAuth
from subprocess import call
import time
import sys

DEFAULT_IP='192.168.50.1'
DEFAULT_PORT=8181

USERNAME='admin'
PASSWORD='admin'
PORT='8181'

REGISTER_NODES_URL="http://%s:8181/restconf/config/opendaylight-inventory:nodes"
OPER_GET1='/restconf/operational/opendaylight-inventory:nodes/'

def get_dpid(host, port,get1,switch_ip,bridge):
    url='http://'+host+":"+str(port)+get1
    #print url
    r = requests.get(url, auth=HTTPBasicAuth(USERNAME, PASSWORD))
    jsondata=json.loads(r.text)
    dpid=""
    for response in jsondata['nodes']['node']:
	node_ip= response['flow-node-inventory:ip-address']
        for nc in response['node-connector']:
            if nc['flow-node-inventory:name'] == bridge and node_ip==switch_ip :
                dpid= response['id'].split(":")[1]
    return dpid

def put(url, data, debug=False):
    '''Perform a PUT rest operation, using the URL and data provided'''

    headers = {'Content-type': 'application/yang.data+json',
               'Accept': 'application/yang.data+json'}
    if debug == True:
        print "PUT %s" % url
        print json.dumps(data, indent=4, sort_keys=True)
    r = requests.put(url, data=json.dumps(data), headers=headers, auth=HTTPBasicAuth(USERNAME, PASSWORD))
    if debug == True:
        print r.text
    r.raise_for_status()


def get_node_config(dpid, sw):
    data = {
        "id": "openflow:{}".format(dpid),
        "ofoverlay:tunnel-ip": sw
    }
    return data

def register_nodes(contHost, nodes):
    data = {"opendaylight-inventory:nodes": {"node": nodes}}
    put(REGISTER_NODES_URL % contHost, data)

if __name__ == '__main__':

    # Some sensible defaults
    I = DEFAULT_IP
    PORT = DEFAULT_PORT

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--ip')
    parser.add_argument('-p', '--port')
    args = parser.parse_args()

    if args.ip:
        I = args.ip
    if args.port:
        PORT = int(args.port)
    #switches=[["br-int","192.168.50.20"],["br-int","192.168.50.21"],["s1","192.168.50.30"]]
    switches=[["br-int","192.168.50.20"],["br-int","192.168.50.21"]]
    nodes=[]
    for sw in switches:
        nodes.append(get_node_config(get_dpid(I,PORT,OPER_GET1,sw[1],sw[0]),sw[1]))

    register_nodes(I,nodes)
