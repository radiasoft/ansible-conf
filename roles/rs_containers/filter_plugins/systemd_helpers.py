import jinja2.tests

def is_iterable(x):
    try:
        iter(x)
    except:
        return False
    return True

def is_string(x):
    if isinstance(x, str) or isinstance(x, unicode):
        return True
    return False

def cmd_arg(cmd_list, arg, val):
    # Always return copies
    cmd_list = list(cmd_list)

    if jinja2.tests.test_defined(val):
        if is_iterable(val) and not is_string(val):
            vals = val
        else:
            vals = [val]

        for v in vals:
            cmd_list.extend([arg, v])

    return cmd_list

def mk_service_name(service_list):
    return [ '{}.service'.format(x) for x in service_list ]


class FilterModule(object):
    def filters(self):
        return {
            'cmd_arg': cmd_arg,
            'mk_service_name': mk_service_name,
        }
