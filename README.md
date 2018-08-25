# Serial <-> LoRa Communicator

A communicator with LoRa through a serial port. This is done by using the LoRa
Wemos module https://github.com/hallard/WeMos-Lora with a Wemos D1 mini pro. The Wemos
is connected to my Pi with USB -> Micro USB.

With this project we can send "commands" to the open LoRa network. Please keep in mind that
the Wemos also needs some firmware for this. This firmware can be found [here](https://github.com/sjoulbak/serial_lora_client)

## Questions

For questions please contact `@sjoulbak` on the Elixir slack.

## Targets

Currently this project only supports the `nerves_system_rpi` project. Since
there should be a special setting enabled before this project can communicate
with the CH341 module. I cloned the `nerves_system_rpi` repo and added this config.
This project has the name `nerves_system_ch341_rpi` and can be found: https://github.com/sjoulbak/nerves_system_ch341_rpi

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=nerves_system_ch341_rpi`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
