#default['firewall']['allow_ssh'] = true
#default['firewall']['firewalld']['permanent'] = true
#default['elkr']['open_ports'] = [8080, 443] 

default['tz'] = "Asia/Bangkok"
default['ntp']['servers'] = [
  '0.pool.ntp.org',
  '1.pool.ntp.org',
  '2.pool.ntp.org'
]

default['elasticsearch']['cluster']['name'] = 'omise-elasticsearch'
default['elasticsearch']['network']['host'] = '0.0.0.0'
default['elasticsearch']['node']['name'] = 'elastic-01'
default['elasticsearch']['node']['master'] = 'true'
default['elasticsearch']['node']['data'] = 'true'
default['elasticsearch']['heap'] = '2g'
default['elasticsearch']['shards'] = '5'
default['elasticsearch']['replicas'] = '1'
default['elasticsearch']['discovery']['zen']['minimum_master_nodes'] = 1
#default['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] =  [ '10.0.0.1', '10.0.0.2', '10.0.0.3' ]

default['elkr']['layer']['redis']['short_name'] = 'redis'
default['elkr']['layer']['elasticsearch']['short_name'] = 'elasticsearch'
default['elkr']['layer']['kibana']['short_name'] = 'kibana'
default['elkr']['layer']['logstash-indexer']['short_name'] = 'logstash-indexer'
default['elkr']['layer']['logstash-shipper']['short_name'] = 'logstash-shipper'




