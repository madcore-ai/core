
name = 'testschedule'
s_mo = '100000000001111110000000'
s_tu = '000000000001111110000000'
s_we = '000000000000000000001111'
s_th = '111111000000000000000000'
s_fr = '000000000000000000000000'
s_sa = '000000000000000000000000'
s_su = '000000000000000000000001'
region = 'eu-west-1'
instanceslist = 'i-39dc50dd,i-4d9b3ac7'
enabled = True




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
                # processing ON schedule
                s = "H(1-5) {1} * * {0}".format(day_of_week_current, hour_of_day_current)
                self.scheds_on.append(s)
                self.scheds_all.append(s)
            elif schedule_currrent is "0" and schedule_previous is "1":
                # processing ON schedule
                s = "H(55-59) {1} * * {0}".format(day_of_week_previous, hour_of_day_previous)
                self.scheds_off.append(s)
                self.scheds_all.append(s)

    def verify_day(self, day):
        if len(day) != 24:
            raise "Day not 24 h."
        return day

    def get_week(self):
        return self.week

    def get_week_day_ints (self, index):
        i_day_of_week = (index / 24) + 1
        i_hour_of_day = index % 24
        i_sched = self.get_week()[index]
        return i_day_of_week, i_hour_of_day, i_sched

    def get_prev_week_day_ints(self, index):
        if index is 0:
            index = 167
        else:
            index = index-1
        return self.get_week_day_ints(index)

c = Cycle(s_mo, s_tu, s_we, s_th, s_fr, s_sa, s_su)
for x in c.scheds_all:
    print x