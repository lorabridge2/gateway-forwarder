# Gateway Forwarder

This repository is part of the [LoRaBridge](https://github.com/lorabridge2/lorabridge) project.
It provides the docker image for the packet forwarding used on our gateway device.

The Packet Forwarder is a self-provided C application based on [this repository](https://github.com/fhessel/dragino_pi_gateway_fwd) that interacts with the LoRaWAN hat. 
It receives the LoRaWAN packets and publishes the data to the Chirpstack Gateway Bridge.

> The original code was patched to use libgiod instead of the gpio sysfs.

## License

All the LoRaBridge software components and the documentation are licensed under GNU General Public License 3.0.

## Acknowledgements

The financial support from Internetstiftung/Netidee is gratefully acknowledged. The mission of Netidee is to support development of open-source tools for more accessible and versatile use of the Internet in Austria.
