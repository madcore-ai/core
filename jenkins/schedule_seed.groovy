job('madcore.scheduler.seed') {
  customWorkspace('/opt/jenkins')
  steps {
    dsl {
      external('schedules/**/*.groovy')
      removeAction('DELETE')
    }
  }
}