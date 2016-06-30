job('df.schedule.set') {
    parameters {
predefinedProp(String key, String value)
choiceParam('myParameterName', ['option 1 (default)', 'option 2', 'option 3'], 'my description')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        shell("echo 'Hello World'")
    }
}
