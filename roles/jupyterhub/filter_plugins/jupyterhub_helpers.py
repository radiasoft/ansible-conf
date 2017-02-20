def user_dirs_to_volumes(user_dirs):
    o = []
    for user_dir in user_dirs:
        host_d = user_dir['host_d']
        o.append('{0}:{0}'.format(host_d))
    return o

class FilterModule(object):
    def filters(self):
        return {
            'user_dirs_to_volumes': user_dirs_to_volumes,
        }
