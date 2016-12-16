job('madcore.plugin.slack.pull') {
    wrappers { preBuildCleanup() }
    parameters {
	    stringParam('REPO_URL', 'git@github.com:madcore-ai/containers.git', '')
        stringParam('APP_NAME', 'slack', '')
        stringParam('SLACK_TOKEN', 'xoxp-102271888193-108964168741-116823616578-24874f6421c8051ac92247b017277533', '')
        stringParam('SLACK_PAYLOAD', '{"channel": "tests"}', '')
        stringParam('S3_BUCKET', 'madcore-core-madcores3bucket-p9pwlahwe6it', '')
    }
    steps {
        def command = """#!/bin/bash
echo "REPO_URL: '\$REPO_URL'"
echo "APP_NAME: '\$APP_NAME'"
echo "SLACK_TOKEN: '\$SLACK_TOKEN'"
echo "SLACK_PAYLOAD: '\$SLACK_PAYLOAD'"
echo "S3_BUCKET: '\$S3_BUCKET'"

    python /opt/madcore/bin/deploy_container.py "\$REPO_URL" "\$APP_NAME" "madcore_slack -t \$SLACK_TOKEN -a pull_messages -b \$S3_BUCKET -p \$SLACK_PAYLOAD"
"""
        shell(command)
    }
}
