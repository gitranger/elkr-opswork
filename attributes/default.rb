default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['elkr']['open_ports'] = [80, 443] 

default['elkr']['user'] = 'web_admin'
default['elkr']['group'] = 'web_admin'
default['elkr']['document_root'] = '/var/www/customers/public_html'
