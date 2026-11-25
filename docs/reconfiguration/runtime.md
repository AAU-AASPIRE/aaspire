# FORTE runtime

<span class="pillar reconfiguration">Reconfiguration</span> Eclipse 4diac FORTE built with your modules'
block types: for Windows (modules with simulated IO) and for 64-bit Linux edge devices such as a
Raspberry Pi (aarch64, real IO). The scripts that check and export the 4diac projects, patch and build
FORTE, package it and put it on a device. Repository
[forte-runtime](https://github.com/AAU-AASPIRE/forte-runtime).

<figure markdown="span">
  [![The 4diac projects on the left, four steps to a FORTE binary in the middle, and where it runs on
  the right](../figures/runtime.png)](../figures/runtime.png)
  <figcaption>Check and export (1), patch FORTE (2), build with the 4diac FORTE Build Environment (3),
  package (4); then a PC, a new device, a running device, or anywhere with the kit.</figcaption>
</figure>

A FORTE runs only programs whose block types it was built with. A new or changed block type (a skill,
an equipment item, a library block) means a new FORTE; a changed program (other instances,
connections, values) does not: it is only deployed. One binary holds every module's types and serves
every device; each device deploys only its own module's program.

## The steps

1. **Check and export** (`validate.ps1`): the 4diac IDE 3.3, headless, checks every type and system and
   exports the types as C++; the library is compiled once.
2. **Patch FORTE 3.3.0** (`forte-patches/`, a stack of patches; header shims in `forte-compat/`): the IO
   handles fixed, a sysfs PWM module, stand-ins for GPIOChip and PWMChip where FORTE has no GPIO
   (Windows).
3. **Build** with the 4diac FORTE Build Environment (FBE): `modules-win` gives `forte.exe`,
   `pi/modules-pi` the aarch64 binary; open62541 and the rest linked statically; the FBE brings the
   cross compiler.
4. **Package** (`build-pi.ps1`): `bin/forte-aarch64` with its checksum, committed, so the installer
   finds it.

In `forte-runtime`:

```powershell
.\build-modules.ps1                       # the line's projects checked and exported, FORTE for Windows
.\build-pi.ps1                            # FORTE for the device, packaged into bin/
.\build-pi.ps1 -SkipValidate              # reuse the last export: only compile and package
.\check-project.ps1 -ProjectDir ../aseptic-line/cell/control/<Module>   # only the IDE's checks
```

Needed once: the 4diac IDE 3.3 (its version must match FORTE's; set `FORDIAC_IDE` to its
`4diac-idec.exe`), the FBE cloned into `C:\4diac-fbe`, Python with aaspire-tools installed, and git.

## Where it runs

| Where | How |
| --- | --- |
| A PC | `forte.exe` with the IO simulated over Modbus: develop and test a module without hardware ([run a module on a PC](../how-to/simulation.md)) |
| A new edge device | `install.sh`: Docker, FORTE in a container with the GPIO chip and the PWM channels, `fake-hwclock`; run again to update, the program is kept ([deploy to an edge device](../how-to/raspberry-pi.md)) |
| A device that runs FORTE | `update-pi.ps1 -Pi user@address`: build, send the binary, rebuild the container, wait until FORTE answers |
| Anywhere, with your own blocks | `make-kit.ps1` makes `forte-kit.zip`: `build-project.ps1 -Project <your project folder>` builds FORTE with your own block types, `install-pi.ps1 -Pi user@address` installs it over SSH, even on a device without internet |

Read further: [building FORTE for the Raspberry Pi](../reference/forte-for-the-pi.md).
