job('df.schedule.set') {
    parameters {
        stringParam('Monday', '', '')
        stringParam('Tuesday', '', '')
        stringParam('Wednesday', '', '')
        stringParam('Thurdsay', '', '')
        stringParam('Friday', '', '')
        stringParam('Saturday', '', '')
        stringParam('Sunday', '', '')
        stringParam('InstanceList', '', '')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        shell('df_schedule_set.sh')
    }
}
