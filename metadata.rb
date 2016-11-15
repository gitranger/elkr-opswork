name 'elkr'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'all_rights'
description 'Installs/Configures elkr'
long_description 'Installs/Configures elkr'
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
# issues_url 'https://github.com/<insert_org_here>/elkr/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
# source_url 'https://github.com/<insert_org_here>/elkr' if respond_to?(:source_url)

depends 'selinux', '~> 0.9'
#depends 'timezone-ii', '~> 0.2.0'
depends 'firewall', '~> 2.5'
depends 'httpd', '~> 0.4'
depends 'ntp', '~> 3.2.0'
depends 'elasticsearch', '~> 3.0.1'
