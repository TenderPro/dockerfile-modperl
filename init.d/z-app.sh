
# Run code before services started
if [ -e init.sh ]; then
  . init.sh
fi

# Run code after services started
if [ -e onboot.sh ]; then
  nohup bash onboot.sh > onboot.log 2>&1 &
  chmod a+r onboot.log
fi
