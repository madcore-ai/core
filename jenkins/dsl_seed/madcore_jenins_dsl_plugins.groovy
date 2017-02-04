job('madcore.jenkins.dsl.seed.plugins') {
    customWorkspace('/opt/plugins')

    scm {
        git {
            remote {
                url('https://github.com/madcore-ai/plugins')
            }
            branch('${MADCORE_PLUGINS_COMMIT}')
        }
    }

    steps {
        dsl {
          external('**/*.groovy')
          removeAction('DELETE')
        }
    }
}
