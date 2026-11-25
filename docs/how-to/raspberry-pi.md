# Deploy a module to an edge device

Run a module's IEC 61499 program on its real IO, on a 64-bit Linux edge device. The tooling is made and
tested for a Raspberry Pi 4 or 5; the commands run from the workspace folder.

!!! danger "Motion"
    A module's Reset and homing can drive its axes to their limit switches, and its skills move them.
    Send them only with someone at the machine who can stop it.

## 1. The device

- A 64-bit Linux (Raspberry Pi OS or Ubuntu), on the network.
- Login with your workstation's SSH key; the user in the groups `docker` and, on Ubuntu, `dialout`
  (the GPIO lines).
- The module's spec names it: the `pi` target in `modules/<module>.yaml` has its `host`, `user` and
  `board` (`pi5` for a Raspberry Pi 5, whose PWM channels are numbered differently).

## 2. FORTE on the device

On the device, once, as a user with sudo:

```bash
curl -fsSL https://raw.githubusercontent.com/AAU-AASPIRE/forte-runtime/main/install.sh | bash
```

It installs Docker if it is missing and starts FORTE in a container with the GPIO lines and the PWM
channels; reboot once for the PWM. Or from your workstation, on a device that has Docker:

```powershell
python deploy/pi.py install --spec <module-spec.yaml> --forte forte-runtime/bin/forte-aarch64
```

A changed block type needs a new FORTE: run `build-pi.ps1` in forte-runtime, commit `bin/`, install
again ([FORTE runtime](../reconfiguration/runtime.md)).

## 3. The module's program

```powershell
python deploy/pi.py module --spec <module-spec.yaml> --print   # look at the boot file first
python deploy/pi.py module --spec <module-spec.yaml>           # deploy it; FORTE restarts
python deploy/pi.py log --spec <module-spec.yaml>
```

The program becomes FORTE's boot file and FORTE restarts, so the module comes back after a reboot.
Keep a copy of the boot file (`~/forte/boot/forte.fboot`) before you replace one. The module starts
Stopped and free.

## 4. Check it

```powershell
python -m modsync pull --host <device address>     # which module runs there, its drift from its spec, its AAS
```

With the registration service running with `--discover`, the module is found and registered by
itself ([register](register.md)). From then on you operate it over OPC UA at
`opc.tcp://<device address>:4840`, like the [simulated one](simulation.md).
