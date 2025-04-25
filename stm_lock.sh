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

TMP_CFG=$(mktemp /tmp/openocd_cfg.XXXXXX)

case $ACTION in
    unlock)
        echo "Unlocking..."
        cat > $TMP_CFG <<EOF
source [find interface/stlink.cfg]
transport select hla_swd
source [find target/stm32f1x.cfg]
init
reset halt
stm32f1x unlock 0
reset halt
exit
EOF
        ;;
    lock)
        echo "Locking..."
        cat > $TMP_CFG <<EOF
source [find interface/stlink.cfg]
transport select hla_swd
source [find target/stm32f1x.cfg]
init
reset halt
stm32f1x lock 0
reset halt
exit
EOF
        ;;
    *)
        echo "Unknown command: $ACTION"
        rm $TMP_CFG
        exit 1
        ;;

esac

echo "Starting openocd..."
openocd -f $TMP_CFG

rm $TMP_CFG

echo "Done"
