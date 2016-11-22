# ELKR - Elasticsearch/Logstash/Kibana/Redis 

logstash shipper: Listen on 8080, accept http json payload and store on Redis  <br>
logstash indexer: Grab json object from redis, store indexes on elasticsearch <br>
redis:  queue service for  json object <br>
elasticsearch: search engine <br>
kibana:  dashboard<br>


### How to connect to Logstash:
- Format of data to be sent
- url:port for staging logstash endoint
- Sample JSON to send
- How to visualize in Kibana (kibana url and authentication)
- How to search directly in ElasticSearch (raills app)

Load Balancers
- Internal ELB for ElasticSearch      elk.es.omise.co
- Internal ELB for Shipper       elk.shipper.omise.co



# test
curl -H "Content-Type: application/json" -XPUT  -d @data.json http://52.220.177.67:8080 <br>

data.json <br>
{ <br>
  "amount": 100025,  <br>
  "currency": "thb",  <br>
  "description": "Order-3456789",  <br>
  "return_uri": "http://localhost/orders/345678/complete",  <br>
  "customer": "user.customer_id",  <br>
  "body": { "name": "usera", "group": "staff"  }  <br>
}  <br>
