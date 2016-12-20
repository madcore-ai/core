from __future__ import print_function
import template
import argparse
import json

OUTPUT_TEMPLATES_DIR = '/opt/jenkins/schedules'


def parse_args():
    """
    Parse arguments for input params
    """

    parser = argparse.ArgumentParser(prog="Jenkins Scheduler Generator")

    parser.add_argument('-j', '--json', required=True, help='Json input with scheduler data')
    parser.add_argument('-ot', '--out_templates_dir', default=OUTPUT_TEMPLATES_DIR,
                        help='Directory to store templates')
    parser.add_argument('-d', '--debug', default=False, action='store_true')

    return parser.parse_args()


class Cycle:
    mon = None
    tue = None
    wed = None
    thu = None
    fri = None
    sat = None
    sun = None
    week = None

    scheds_on = None
    scheds_off = None
    scheds_all = None

    def __init__(self, mo, tu, we, th, fr, sa, su):

        self.scheds_on = []
        self.scheds_off = []
        self.scheds_all = []

        self.mon = self.verify_day(mo)
        self.tue = self.verify_day(tu)
        self.wed = self.verify_day(we)
        self.thu = self.verify_day(th)
        self.fri = self.verify_day(fr)
        self.sat = self.verify_day(sa)
        self.sun = self.verify_day(su)

        self.week = '{0}{1}{2}{3}{4}{5}{6}'.format(self.mon, self.tue, self.wed, self.thu, self.fri, self.sat, self.sun)

        for i, s in enumerate(self.get_week()):
            day_of_week_current, hour_of_day_current, schedule_currrent = self.get_week_day_ints(i)
            day_of_week_previous, hour_of_day_previous, schedule_previous = self.get_prev_week_day_ints(i)

            if schedule_currrent is "1" and schedule_previous is "0":
                # processing ON schedule (start of an hour)
                sch = "H(1-5) {1} * * {0}".format(day_of_week_current, hour_of_day_current)
                self.scheds_on.append(sch)
                self.scheds_all.append(sch)
            elif schedule_currrent is "0" and schedule_previous is "1":
                # processing OFF schedule (end of an hour)
                sch = "H(55-59) {1} * * {0}".format(day_of_week_previous, hour_of_day_previous)
                self.scheds_off.append(sch)
                self.scheds_all.append(sch)

    def verify_day(self, day):
        if len(day) != 24:
            raise Exception("Day not 24 h.")
        return day

    def get_week(self):
        return self.week

    def get_week_day_ints(self, index):
        i_day_of_week = (index / 24) + 1
        i_hour_of_day = index % 24
        i_sched = self.get_week()[index]
        return i_day_of_week, i_hour_of_day, i_sched

    def get_prev_week_day_ints(self, index):
        if index is 0:
            index = 167
        else:
            index -= 1
        return self.get_week_day_ints(index)


if __name__ == '__main__':
    args = parse_args()
    input_data = json.loads(args.json)
    c = Cycle(input_data['s_mo'], input_data['s_tu'], input_data['s_we'], input_data['s_th'], input_data['s_fr'],
              input_data['s_sa'], input_data['s_su'])

    if args.debug:
        for x in c.scheds_all:
            print(x)

    if isinstance(input_data['instances_list'], list):
        input_data['instances_list'] = ','.join(input_data['instances_list'])

    tmpl_data = {"region": input_data['region'], 'instances_list': input_data['instances_list'],
                 "disabled": str(not input_data['enabled']).lower()}
    template = template.Template(input_data['name'], c)
    template.generate_dsl_schedule(args.out_templates_dir, tmpl_data)
