job('example-job-from-job-dsl') {
    scm {
        github('jenkinsci/job-dsl-plugin', 'master')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        shell("echo 'Hello World'")
    }
}
