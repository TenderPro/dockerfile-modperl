#!/bin/bash

# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Run command via uid of current user ($FLAG owner)
root=$PWD

# Change user id to FLAG owner's uid
#FLAG_UID=$(stat -c "%u" $FLAG)
#if [[ "$FLAG_UID" ]] && [[ $FLAG_UID != $(id -u $APPUSER) ]]; then
#  echo "Set uid $FLAG_UID for user $APPUSER"
#  usermod -u $FLAG_UID $APPUSER
#  chown -R $APPUSER /home/op
#fi


function gracefulShutdown {
  echo "Shutting down!"
  /usr/local/apache/bin/apachectl stop

}

serve() {

  if [ -d /init.d ]; then
    for f in /init.d/*.sh; do
      [ -f "$f" ] && echo  "Run $f.." && . "$f"
    done
  fi

  trap gracefulShutdown SIGTERM

  /usr/local/apache/bin/apachectl start
  /usr/bin/supervisord

}

echo "Starting: $@"
if [[ "$1" == "server" ]] ; then
  serve
elif [[ "$1" == "wait" ]] ; then
  while [ 1 ]
  do
    sleep 60 &
    wait $!
  done
else 
  exec "$@"
fi
