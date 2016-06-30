job('df.schedule.set') {
    parameters {
    stringParam('VERSION', '10.2.0.0', '')
    stringParam('BRANCH', 'master', '')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        shell("echo 'Hello World'")
    }
}
