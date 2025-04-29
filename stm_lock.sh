#!/bin/bash

if ! command -v openocd &> /dev/null; then
    echo "openocd not found"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Use: $0 <argument>"
    echo "Arguments: lock/unlock"
    exit 1
fi

ACTION=$1


case $ACTION in
    unlock)
        echo "Unlocking..."
        openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "init" -c "reset halt" -c "stm32f1x unlock 0" -c "exit"
        ;;
    lock)
        echo "Locking..."
        openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "init" -c "reset halt" -c "stm32f1x lock 0" -c "exit"
        ;;
    *)
        echo "Unknown command: $ACTION"
        rm $TMP_CFG
        exit 1
        ;;

esac

echo "Done"
