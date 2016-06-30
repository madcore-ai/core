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
        shell("echo 'Sunday: $Sunday'")
        shell("echo 'Monday: $Monday'")
        shell("echo 'Tuesday: $Tuesday'")
        shell("echo 'Wednesday: $Wednesday'")
        shell("echo 'Thurdsay: $Thursday'")
        shell("echo 'Friday: $Friday'")
        shell("echo 'Saturday: $Saturday'")
        shell("echo 'InstanceList: $InstanceList'")
    }
}
