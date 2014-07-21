# Default attributes

default[:twoscoops][:project_name] = nil
default[:twoscoops][:application_name] = nil
default[:twoscoops][:application_revision] = nil

default[:twoscoops][:application_path] = "/vagrant"
default[:twoscoops][:application_environment] = "local"

default[:twoscoops][:database][:engine] = "django.db.backends.postgresql_psycopg2"
default[:twoscoops][:database][:username] = "vagrant"
default[:twoscoops][:database][:password] = "vagrant"
default[:twoscoops][:database][:host] = "127.0.0.1"
default[:twoscoops][:database][:port] = ""

default[:twoscoops][:createsuperuser] = true
default[:twoscoops][:superuser][:username] = "vagrant"
default[:twoscoops][:superuser][:password_hash] = "pbkdf2_sha256$10000$NoIByEhX0v78$UgkCwmSHBNYiFPD0zCkZ9x+S7z5tlRysHv/L68OJdxc="

default[:twoscoops][:django][:autostart] = true
default[:twoscoops][:celeryd][:autostart] = true
default[:twoscoops][:celerybeat][:autostart] = true

default[:twoscoops][:cache][:backend] = "django.core.cache.backends.memcached.MemcachedCache"
default[:twoscoops][:cache][:location] = "127.0.0.1:11211"

default[:twoscoops][:celery][:celery_result_backend] = "amqp"
default[:twoscoops][:celery][:broker_url] = "amqp://guest:guest@localhost:5672/"
default[:twoscoops][:celery][:concurrency] = 2
default[:twoscoops][:celery][:loglevel] = "INFO"
default[:twoscoops][:celery][:queues] = nil

default[:twoscoops][:celerybeat][:schedule_filename] = "/var/lib/celery/celerybeat_schedule"

default[:twoscoops][:raven][:dsn] = nil

default[:twoscoops][:test][:command] = "jenkins"
