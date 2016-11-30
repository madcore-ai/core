from __future__ import print_function
import sys
import subprocess


def run_cmd(cmd, debug=True):
    if debug:
        print("Running cmd: %s" % cmd)
        sys.stdout.flush()

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
    out, err = process.communicate()

    if err:
        print("    ERROR: ", err)
    else:
        print("    OK")

    return out.strip()


def run_cmd_no_debug(cmd):
    run_cmd(cmd, debug=False)
