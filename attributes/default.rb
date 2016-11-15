#default['firewall']['allow_ssh'] = true
#default['firewall']['firewalld']['permanent'] = true
#default['elkr']['open_ports'] = [8080, 443] 

default['tz'] = "Asia/Bangkok"
default['ntp']['servers'] = [
    '0.pool.ntp.org',
    '1.pool.ntp.org',
    '2.pool.ntp.org',
    '3.pool.ntp.org'
]

default['elkr']['cluster']['name'] = 'omise-elasticsearch'
default['elkr']['layer']['redis']['short_name'] = 'redis'
default['elkr']['layer']['elasticsearch']['short_name'] = 'elasticsearch'
default['elkr']['layer']['kibana']['short_name'] = 'kibana'
default['elkr']['layer']['logstash-indexer']['short_name'] = 'logstash-indexer'
default['elkr']['layer']['logstash-shipper']['short_name'] = 'logstash-shipper'



