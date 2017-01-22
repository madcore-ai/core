job('madcore.jenkins.dsl.seed.plugins') {
    customWorkspace('/opt/plugins')

    scm {
        git {
            remote {
                url('https://github.com/madcore-ai/plugins')
            }
            branch('master')
        }
    }

    steps {
        dsl {
          external('**/*.groovy')
          removeAction('DELETE')
        }
    }
}
