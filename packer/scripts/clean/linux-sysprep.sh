#!/bin/sh
# sysprep.sh - Prepare machine for use as template
#
# This script was designed to be compatible with all Linux systems with a
# GNU-based userspace, but was only tested on RHEL7
#
set -x

usage() {
    cat 1>&2 <<EOF
Usage \$0 [OPTIONS]
Prepare system for use as template.
  -f            Actually do something, don't just say it
  -h            Print this help message
EOF
}

verbose() {
    echo "\$@"
}

do_cmd() {
    verbose "    [ \$@ (noop) ]"
}

really_do_cmd() {
    verbose "    [ \$@ ]"
    cmd="\$1"
    shift
    \$cmd "\$@"
}

main() {
    parse_args "\$@"
    remove_rhsm_id
    remove_ssh_keys
    remove_net_persistent
    remove_hostname
    remove_machine_id
#    remove_homes
    clean_logs
    clean_yum
    clean_user_history

}

parse_args() {
    while getopts 'fh' opt; do
        case "$opt" in
        f)
            do_cmd() {
                really_do_cmd "$@"
            }
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
        esac
    done
}

remove_rhsm_id() {
    verbose 'Revoming RHSM system ID'
    do_cmd subscription-manager remove --all
    do_cmd subscription-manager unregister
    do_cmd subscription-manager clean
    do_cmd subscription-manager clean
}

remove_ssh_keys() {
    verbose 'Removing ssh keys'
    for key in /etc/ssh/ssh_host_*; do
        [ -f "\$key" ] || continue
        verbose "- \$key"
        do_cmd rm -f "\$key"
    done
}

remove_net_persistent() {
    rules='/etc/udev/rules.d/70-persistent-net.rules'
    [ -f "\$rules" ] || return
    verbose 'Removing persistent net UDEV rules'
    do_cmd rm -f "\$rules"
}

remove_hostname() {
    verbose 'Removing fixed hostname'
    do_cmd rm -f '/etc/hostname'
}

remove_machine_id() {
    local machine_id='/etc/machine-id'
    [[ -r "\$machine_id" ]] || return
    # If the system is setup with a machine-id bind-mounted from a tempfs, we
    # can't and don't need to empty it
    grep -qF "\$machine_id" /proc/mounts && return
    verbose 'Removing machine-id'
    do_cmd write_file "\$machine_id" < /dev/null
}

clean_logs() {
    verbose 'Cleaning up logfiles'
    find /var/log -type f | while read log; do
        [ -f "\$log" ] || continue
        verbose "- \$log"
        do_cmd rm -f "\$log"
    done
}

clean_yum() {
    verbose 'Cleaning Yum files database history'
        do_cmd yum clean all
        do_cmd yum history new
}

clean_user_history() {
    verbose 'Cleaning user bash history'
    do_cmd find /home -iname .bash_history -exec rm {} \;
    do_cmd rm -rf /tmp/*
    do_cmd rm -rf /var/tmp/*
}

write_file() {
    cat > "\$1"
}

main "\$@"
exit 0