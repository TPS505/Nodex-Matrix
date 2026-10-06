# Nodex Matrix

ESPHome LED matrix display: Adafruit Matrix Portal S3 + 64x64 HUB75 RGB panel.
Shows a clock, scrolling messages, notifications and an info screen you fill from Home Assistant.

Needs Home Assistant 2026.x (and ESPHome 2026.9 or newer to take control of it).

## Setup

1. Plug the Matrix Portal into USB-C power. The panel shows **SETUP**.
2. On your phone, join the Wi-Fi network **Nodex Matrix Setup** (or scan the QR code the panel shows).
3. A page opens; choose your Wi-Fi network and enter the password.
4. In Home Assistant, a notification appears: **New device discovered**. Click **Configure**.

You can also set up Wi-Fi from the Home Assistant app over Bluetooth, or over USB.
Setup has to finish within 15 minutes of plugging in; if the panel says **SETUP TIMED OUT**, unplug it and plug it back in.

## Buttons

| Button | Press | Hold |
|---|---|---|
| Up | Next screen | 1 s: display on/off |
| Down | Brightness step | 10 s: factory reset (the panel counts down; let go to cancel) |

Both buttons also appear in Home Assistant as events, so you can use them in automations.

## Screens

Pick one with **Screen** in Home Assistant, or press Up.

| Screen | Shows |
|---|---|
| Clock | Day, time, date and a seconds bar |
| Info | A title and up to 6 label/value rows sent from Home Assistant |
| Rotate | Clock and Info, 10 s each |
| Clock + Message | Time with your **Message** scrolling underneath |
| Message | Your **Message** in large scrolling text |

**Display** is a light: turn it off or dim it. **Theme colour** sets the accent colour.

## Home Assistant actions

The device name is part of each action, e.g. `esphome.nodex_matrix_a1b2c3_set_tile`.

| Action | Data | What it does |
|---|---|---|
| `show_notification` | `message`, `seconds` | Full-screen message for that long |
| `clear_notification` | | Removes it early |
| `set_info_title` | `title` | Heading of the Info screen |
| `set_tile` | `index` (0-5), `label`, `value` | One row of the Info screen |
| `clear_tiles` | | Empties the Info screen |

Info rows aren't kept through a restart, so push them from an automation on a timer.
[homeassistant/energy-on-matrix.example.yaml](homeassistant/energy-on-matrix.example.yaml) is an example that shows Octopus Energy readings.

## Customising

In the ESPHome dashboard, the device shows as discovered. Click **Take Control** to
copy this config into your own ESPHome and change anything you like.

## Hardware

* 64x64 panels need the address **E** line: solder the E jumper on the back of the Matrix Portal S3 to pin 8.
  If the bottom half of the panel repeats the top half, the jumper isn't closed.
* Give the panel its own 5 V supply; full white draws several amps.

## Updates

New firmware appears in Home Assistant as **Firmware update available** on the device. Click **Install**.

To publish one: bump `version:` in `nodex-matrix.yaml`, run `./release.sh`, then commit and push `docs/`.
