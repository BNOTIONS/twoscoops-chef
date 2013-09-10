CACHES = {
    'default': {
        'BACKEND': '<%= node['twoscoops']['cache']['backend'] %>',
        'LOCATION': '<%= node['twoscoops']['cache']['location'] %>'
    }
}
