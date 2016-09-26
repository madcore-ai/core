from jinja2 import Environment, PackageLoader
import os
from prettytable import PrettyTable


class Struct:
    def __init__(self, **entries):
        self.__dict__.update(entries)


class Template(object):

    name = None
    cycles = None

    def __init__(self, in_name, in_cycles):
        self.name = in_name
        self.cycles = in_cycles

    def generate_dsl_schedule(self):
        env = Environment(loader=PackageLoader('template', './templates'))
        template = env.get_template("my_schedulename_stop.groovy")
        rendered = template.render(name=self.name, cycles=self.cycles)
        pa = "/tmp/template/"
        if not os.path.exists(pa):
            os.makedirs(pa)
        fi = "my.schedule.{0}.start.groovy".format(self.name)
        si = len(rendered)
        template_save_path = pa + fi
        with open(template_save_path, "wb") as f:
            f.write(rendered.encode("UTF-8"))
        f.close()
        return pa, fi, si


        def generate_all_templates(self):
                x = PrettyTable(["Generated schedule templates from bin/templates", "Name", "Size"])
                x.padding_width = 1
                for host_group in self.settings.host_groups:
                    pa, fi, si = self.generate_hostgroup_template(host_group)
                    x.add_row([pa, fi, si])
                print x

        def generate_hostgroup_template(self, host_group):
            hg = Struct(**host_group)
            env = Environment(loader=PackageLoader('template', '../templates'))
            template = env.get_template(hg.heat_template)
            rendered = template.render(host_group, team=self.settings.cluster.team, env_openstack=self.settings.cluster.env_type, cluster_id=self.settings.cluster.cluster_id)
            pa = "../clusters/" + self.settings.cluster.env_type + "-" + self.settings.cluster.cluster_id + "/"
            if not os.path.exists(pa):
                os.makedirs(pa)
            fi = hg.host_group_id + ".yaml"
            si = len(rendered)
            template_save_path = pa + fi
            with open(template_save_path, "wb") as f:
                f.write(rendered.encode("UTF-8"))
            f.close()
            return pa, fi, si

