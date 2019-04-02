#!/usr/bin/env bash
set -euo pipefail

if ! test -d public; then make -j public; fi

cat <<EOF
== 👋 Hello! ==================================================================

I'm watching files in styleguide-app and src for changes. If you make any
changes, I'll try to be smart about what should change (things end up in the
"public" directory if you want to check my work.) If you remove a file and it's
still showing up, delete the "public" directory and restart me.

To rebuild manually, hit SPC.

To quit, hit "q" or ctrl-c.

== thaaat's it from me! =======================================================

EOF

# start a web server, and tear it down with the rest of the process
./script/serve.sh public &
SERVER_PID=$!
cleanup() {
    kill "$SERVER_PID"
}
trap cleanup EXIT INT

# start a watcher. This loops forever, so we don't need to loop ourselves.
find src styleguide-app -type f -not -ipath '*elm-stuff*' | entr -c -p make public
