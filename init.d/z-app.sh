
# Run code before services started
if [ -e $APP_ROOT/init.sh ]; then
  pushd $APP_ROOT
  . init.sh
  popd
fi

