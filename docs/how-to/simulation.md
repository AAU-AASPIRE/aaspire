# Run a module on a PC

Run a module on your PC with its IO simulated: a Modbus simulator stands in for the hardware, FORTE
runs the module's program, and the module answers on OPC UA exactly as it would on its device. This is
the way to develop and test a module before any hardware exists. Windows, with Python 3.11.

## 1. Install

```powershell
mkdir AAU-AASPIRE; cd AAU-AASPIRE
git clone https://github.com/AAU-AASPIRE/aaspire.git
aaspire\workspace\clone.ps1 -Install       # every repository beside it, the Python parts installed
cd aseptic-line                            # the line's repository; the commands below run here
```

The commands use the example line's modules; for your own line, use your line's repository and specs
the same way.

## 2. FORTE for Windows

The module's program needs a FORTE built with its block types. forte-runtime's `build-modules.ps1`
builds it (once the 4diac IDE and the FBE are installed, see [FORTE runtime](../reconfiguration/runtime.md))
into `../forte-runtime/fbe/build/modules-win/output/bin/forte.exe`.

## 3. Start the module

```powershell
python cell/sim/run_module.py cell/modules/<module>.yaml
python cell/sim/run_module.py cell/modules/<other module>.yaml --opcua-port 4841 --mgmt-port 61500   # a second one beside it
```

It starts the simulator and FORTE (`--forte` names another binary) and deploys the PC target's
application. The module answers on `opc.tcp://localhost:4840` until Ctrl+C. `--no-deploy` leaves FORTE
empty, for a deployment from the 4diac IDE.

## 4. Operate it

Every module offers the same OPC UA interface below `/Objects/<Module>`:

| Node | What |
| --- | --- |
| `Occupation/Occupy(Session)`, `Release(Session)` | take and give back the module; the session is any id you choose (a UUID) |
| `Module/Reset`, `Start`, `Stop`, `Abort`, `Clear` `(Session)`; `State` | its PackML state |
| `Skills/<Skill>/Start(Session, parameters...)`, `Stop`, `Abort`, `Reset`; `State`, `ErrorID`, `Results` | a skill |
| `Equipment/<Item>/...` | the equipment's values |

With any OPC UA client (UaExpert, for example): occupy, Reset and Start the module, then start a skill
with the same session id, and watch its `State` turn Succeeded. Or use the HMI, once the module's AAS
is on an AAS server ([register](register.md)): `cd ../iec61499-opcua-hmi; python run.py --aas
http://localhost:8081`.

## 5. Watch it in the 4diac IDE

Import `cell/control/<Module>` into a 4diac IDE 3.3 workspace without copying it, open the system, and
watch the application online on the device at `localhost:61499`: the tools deploy the program inside
the application's container, as the IDE does, so the IDE sees what runs.
