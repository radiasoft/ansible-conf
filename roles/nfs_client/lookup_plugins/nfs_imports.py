from ansible.plugins.lookup import LookupBase

class LookupModule(LookupBase):
    def run(self, terms, variables=None, **kwargs):
        nfs_exports = 'nfs_exports'

        import_group = terms.pop()
        groups = variables['groups']
        hostvars = variables['hostvars']

        o = []
        for hostname in groups['all']:
            host = hostvars[hostname]
            for export in host.get(nfs_exports, {}).get(import_group, []):
                o.append({'hostname':hostname, 'name':export['name']})

        return o
