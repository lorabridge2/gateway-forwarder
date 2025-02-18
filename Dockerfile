ARG  IMG_VERSION=3.21
FROM alpine:${IMG_VERSION} as build

WORKDIR /home/lora
RUN apk update
# alpine 3.15 install wiringpi 2.50-r0 which does not work:
# 000000000 HAL: Initializing ...
# HAL: There is an issue with the SPI communication to the radio module.
# HAL: Make sure that 
# HAL: * The radio module is attached to your Raspberry Pi
# HAL: * The power supply provides enough power
# HAL: * SPI is enabled on your Raspberry Pi. Use the tool "raspi-config" to enable it.
# 000000001 HAL: Failed. Aborting.

# alpine edge install wiringpi 2.61-r0 which works with --privileged
RUN apk add --no-cache build-base linux-headers libgpiod-dev python3-dev python3 py3-pip
# RUN apk add --no-cache wiringpi-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# COPY . .
COPY lora_pkt_fwd/ lora_pkt_fwd/ 
COPY libloragw/ libloragw/
COPY VERSION VERSION

WORKDIR /home/lora/libloragw
RUN make
WORKDIR /home/lora/lora_pkt_fwd
RUN rm global_conf.json
RUN make

RUN pip install gpiod --break-system-packages

FROM alpine:${IMG_VERSION}
WORKDIR /home/lora

RUN apk add --no-cache libgpiod-dev python3
# RUN apk update
# RUN apk add --no-cache hiredis
# RUN apk add --no-cache wiringpi --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
# #--repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
# WORKDIR /home/lora
# COPY --from=build /home/lora/lmic-rpi-lora-gps-hat/examples/transmit/build/transmit.out /home/lora/transmit.out
# RUN pip install gpiod --break-system-packages

COPY --from=build /home/lora/lora_pkt_fwd/lora_pkt_fwd /home/lora/lora_pkt_fwd/lora_pkt_fwd
COPY --from=build /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages

# ENTRYPOINT [ "tail", "-f", "/dev/null" ]
# COPY reset_lgw.sh /home/lora/
COPY reset.py /home/lora/
COPY lora_pkt_fwd/global_conf.json lora_pkt_fwd/global_conf.json
WORKDIR /home/lora/lora_pkt_fwd

ENTRYPOINT ["/bin/sh", "-c"]
# ENTRYPOINT ["/bin/sh", "-c", "/home/lora/lora_pkt_fwd/lora_pkt_fwd"]
# "/home/lora/lora_pkt_fwd/lora_pkt_fwd" 
CMD [ "python /home/lora/reset.py && /home/lora/lora_pkt_fwd/lora_pkt_fwd" ]
