# ELKR - Elasticsearch/Logstash/Kibana/Redis 
Prerequisite: 
 - Vagrant
 - Virtualbox
 - kitchen gem
 
gem list | grep kitchen <br>
kitchen-dokken (1.0.3)  <br>
kitchen-ec2 (1.2.0) <br>
kitchen-inspec (0.15.2) <br>
kitchen-nodes (0.8.0) <br>
kitchen-vagrant (0.20.0) <br>
test-kitchen (1.13.2)<br>

will create 5 instances on virtualbox <br>
logstash shipper: Listen on 5500, accept http json payload and store on Redis instance <br>
logstas indexer: Grab json in redis and store in elasticsearch instance <br>
redis: is queue for  json object <br>
elasticsearch: store all objects <br>
kibana:  dashboard<br>

# provision <br>
cd elrk-kitchen/ <br>
kitchen converge <br>

# test
curl -H "Content-Type: application/json" -XPUT  -d @data.json http://192.168.33.30:5500 <br>

data.json <br>
{ <br>
  "amount": 100025,  <br>
  "currency": "thb",  <br>
  "description": "Order-3456789",  <br>
  "return_uri": "http://localhost/orders/345678/complete",  <br>
  "customer": "user.customer_id",  <br>
  "body": { "name": "usera", "group": "staff"  }  <br>
}  <br>
