job('my_test_job') {
    scm {
        github('jenkinsci/job-dsl-plugin', 'master')
    }
    triggers {
        cron("@hourly")
    }
    steps {
        shell("echo 'Hello Jenkins'")
    }
}