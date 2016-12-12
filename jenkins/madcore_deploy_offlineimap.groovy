job('madcore.deploy.offlineimap') {
    wrappers { preBuildCleanup() }
    parameters {
        stringParam('REMOTE_USER', 'coxodox@gmail.com', '')
        stringParam('OAUTH2_CLIENT_ID', '846427981560-l7a2oeb1m29moj183l9g0ruq0vlbbuic.apps.googleusercontent.com', '')
        stringParam('OAUTH2_CLIENT_SECRET', 'YjYdktcPwa-RBomNZvkuuTMx', '')
        stringParam('OAUTH2_REFRESH_TOKEN', '1/yR5OP7m9DnSY6oN7wvVhOYXQNSp9k9cYkjupdcyWLsjkWA7wEA-rykT_11sJkyyX', '')
        stringParam('APP_NAME', 'offlineimap', '')
    }
    steps {
        def command = """#!/bin/bash
echo "REMOTE_USER: '\$REMOTE_USER'"
echo "OAUTH2_CLIENT_ID: '\$OAUTH2_CLIENT_ID'"
echo "OAUTH2_CLIENT_SECRET: '\$OAUTH2_CLIENT_SECRET'"
echo "OAUTH2_REFRESH_TOKEN: '\$OAUTH2_REFRESH_TOKEN'"
echo "APP_NAME: '\$APP_NAME'"

    python /opt/madcore/bin/deploy_offlineimap.py "\$REMOTE_USER" "\$OAUTH2_CLIENT_ID" "\$OAUTH2_CLIENT_SECRET" "\$OAUTH2_REFRESH_TOKEN" "\$APP_NAME"
"""
        shell(command)
    }
}
