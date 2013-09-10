INSTALLED_APPS += ( 'raven.contrib.django.raven_compat', )

RAVEN_CONFIG = {
    'dsn': '<%= node[:twoscoops][:raven][:dsn] %>',
}

LOGGING['root'] = {
    'level': 'WARNING',
    'handlers': ['sentry']
}
LOGGING['handlers']['sentry'] = {
    'level': 'DEBUG',
    'class': 'raven.contrib.django.handlers.SentryHandler'
}
LOGGING['handlers']['console'] = {
    'level': 'DEBUG',
    'class': 'logging.StreamHandler',
    'formatter': 'verbose'
}
LOGGING['loggers']['raven'] = {
    'level': 'ERROR',
    'handlers': ['console'],
    'propagate': False
}
LOGGING['loggers']['sentry.errors'] = {
    'level': 'ERROR',
    'handlers': ['console'],
    'propagate': False
}
