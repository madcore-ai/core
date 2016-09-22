
name = 'testschedule'
s_mo = '000000000001111110000000'
s_tu = '000000000001111110000000'
s_we = '000000000000000000001111'
s_th = '111111000000000000000000'
s_fr = '000000000000000000000000'
s_sa = '000000000000000000000000'
s_su = '000000000000000000000000'
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

    def __init__(self, mo, tu, we, th, fr, sa, su):
        self.mon = self.verify_day(mo)
        self.tue = self.verify_day(tu)
        self.wed = self.verify_day(we)
        self.thu = self.verify_day(th)
        self.fri = self.verify_day(fr)
        self.sat = self.verify_day(sa)
        self.sun = self.verify_day(su)

        self.week = '{0}{1}{2}{3}{4}{5}{6}'.format(self.mon, self.tue, self.wed, self.thu, self.fri, self.sat, self.sun)

    def verify_day(self, day):
        if len(day) != 24:
            raise "Day not 24 h."
        return day

    def get_week(self):
        return self.week


c = Cycle(s_mo, s_tu, s_we, s_th, s_fr, s_sa, s_su)
print c.get_week()

# first hour of week we're not sure always run
# every other hour we can look back to previous hor to determine if state has changed