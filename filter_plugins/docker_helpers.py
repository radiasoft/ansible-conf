import socket

def docker_add_hosts(domains):
    return [ '{0}:{1}'.format(d, socket.gethostbyname(d)) for d in domains ]

class FilterModule(object):
    def filters(self):
        return {
             'docker_add_hosts': docker_add_hosts,
        }
