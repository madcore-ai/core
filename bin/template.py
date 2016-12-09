from jinja2 import Environment, PackageLoader
import os


class Struct:
    def __init__(self, **entries):
        self.__dict__.update(entries)


class Template(object):
    name = None
    cycles = None

    def __init__(self, in_name, in_cycles):
        self.name = in_name
        self.cycles = in_cycles
        self.env = Environment(loader=PackageLoader('template', './templates'))

    def generate_dsl_schedule(self, output_template_path, data):
        results = []
        results += self.generate_dsl_job_schedule('start', output_template_path, data)
        results += self.generate_dsl_job_schedule('stop', output_template_path, data)

        return results

    def generate_dsl_job_schedule(self, job_type, output_template_path, data):
        template_name = 'my_schedulename_{0}.groovy'.format(job_type)
        template = self.env.get_template(template_name)
        rendered = template.render(name=self.name, cycles=self.cycles, **data)
        if not os.path.exists(output_template_path):
            os.makedirs(output_template_path)

        fi = "madcore.schedule.{0}.{1}.groovy".format(self.name, job_type)
        si = len(rendered)
        template_save_path = os.path.join(output_template_path, fi)
        with open(template_save_path, "wb") as f:
            f.write(rendered.encode("UTF-8"))
        f.close()

        return output_template_path, fi, si
