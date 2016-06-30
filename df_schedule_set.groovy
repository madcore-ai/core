job('df.schedule.set') {
    triggers {
        cron("@hourly")
    }
    steps {
        shell("echo 'Hello World'")
    }
}
