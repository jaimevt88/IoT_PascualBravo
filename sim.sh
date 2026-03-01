#!/bin/bash

BROKER="192.168.56.104"   # <-- cambia a la IP de tu mosquitto
TOPIC1="laboratorio/sensor1/temperatura"
TOPIC2="laboratorio/sensor2/temperatura"

# valores base (temperatura ambiente)
t1=23.0
t2=27.0

while true
do
    # variación lenta tipo física real
    t1=$(LC_NUMERIC=C awk -v t="$t1" 'BEGIN{srand(); t+=(-0.3+rand()*0.6); printf "%.2f", t}')
    t2=$(LC_NUMERIC=C awk -v t="$t2" 'BEGIN{srand(); t+=(-0.4+rand()*0.8); printf "%.2f", t}')
    # evento ocasional (simula puerta abierta, sol, equipo encendido)
    r=$((RANDOM % 40))
    if [ "$r" -eq 5 ]; then
        t2=$(awk -v t="$t2" 'BEGIN{printf "%.2f", t+5}')
        echo ">> Evento térmico en sensor2"
    fi

    payload1="{\"valor\":$t1,\"unidad\":\"C\"}"
    payload2="{\"valor\":$t2,\"unidad\":\"C\"}"

    mosquitto_pub -h $BROKER -t $TOPIC1 -m "$payload1"
    mosquitto_pub -h $BROKER -t $TOPIC2 -m "$payload2"

    echo "sensor1: $t1 °C | sensor2: $t2 °C"

    sleep 2
done
