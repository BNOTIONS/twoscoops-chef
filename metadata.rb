name             'twoscoops'
maintainer       'BNOTIONS'
maintainer_email 'jonathon@bnotions.com'
license          'All rights reserved'
description      'Installs/Configures Django application stacks based on our custom twoscoops template'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.24'

depends          'build-essential'
depends          'python'
depends          'supervisor'
depends          'database'
depends          'postgresql'
depends          'memcached'
depends          'nginx'
depends          'uwsgi'
depends          'rabbitmq'
depends          'application'
