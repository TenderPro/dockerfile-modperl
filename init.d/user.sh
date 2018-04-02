
if [[ "$APP_USER" ]]; then
  # Check if user exists already
  grep -qe "^$APP_USER:" /etc/passwd || useradd -m -r -s /bin/bash -Gwww-data -gusers -gsudo $APP_USER
fi
