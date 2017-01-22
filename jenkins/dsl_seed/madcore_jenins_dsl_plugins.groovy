job('madcore.jenkins.dsl.seed.plugins') {
    customWorkspace('/opt/plugins')

    parameters {
        stringParam('BRANCH', 'master', '')
    }
    scm {
        git {
            remote {
                url('https://github.com/madcore-ai/plugins')
            }
            branch(params.BRANCH)
        }
    }

    steps {
        dsl {
          external('**/*.groovy')
          removeAction('DELETE')
        }
    }
}
