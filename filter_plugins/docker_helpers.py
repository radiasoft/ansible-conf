import socket

def docker_add_hosts(domains):
    return [ '{0}:{1}'.format(d, socket.gethostbyname(d)) for d in domains ]

def docker_get_ip(domain):
    return socket.gethostbyname(domain)

class FilterModule(object):
    def filters(self):
        return {
            'docker_add_hosts': docker_add_hosts,
            'docker_get_ip': docker_get_ip,
        }
