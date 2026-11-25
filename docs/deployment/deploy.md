# Deployment

<span class="pillar deployment">Deployment</span> A line needs two kinds of deployment: the server stack
that holds the AASs and the services around them, started on one computer with Docker Compose, and each
module's device, turned into an IEC 61499 module that runs FORTE. Repository
[deploy](https://github.com/AAU-AASPIRE/deploy), with the device installer in
[forte-runtime](https://github.com/AAU-AASPIRE/forte-runtime).

<figure markdown="span">
  [![The server stack's containers on the left with the processes beside it; an edge device with its
  FORTE container, ports and manifest server on the right, reached from a workstation over SSH](../figures/deploy.png)](../figures/deploy.png)
  <figcaption>The stack runs the AAS server, the DMP, the time series, the brokers and the web UI; a
  device runs FORTE in a container and serves its module's profiles; the registration service finds it.</figcaption>
</figure>

## The server stack

| Container | Port | Does |
| --- | --- | --- |
| AAS environment (BaSyx) | 8081 | The shells and submodels; in memory, so the AASs are published again after a restart |
| AAS and submodel registries, discovery (BaSyx) | | Where each AAS and submodel is |
| web UI | 3000 | The [apps](../interfaces/web-ui.md) |
| DMP | 8085 | AAS Operations to OPC UA, values to the time series ([DMP](../integration/dmp.md)) |
| InfluxDB | 8086 | The time series; its data kept in a volume |
| Mosquitto | 1883 | The AAS server's events (a shell or submodel created, changed, deleted) |
| Prosody | 5222 | XMPP for the [agents](../execution/agents.md) |

From the workspace folder:

```powershell
python deploy/aas.py up                 # writes the secrets to deploy/aas/.env if there are none, starts it all
python deploy/aas.py status             # the containers, and what the DMP made of the mappings
python deploy/aas.py rows <Module>AAS   # a module's latest values
python deploy/aas.py logs dmp
python deploy/aas.py down
```

Beside the stack, run as processes: the registration service (`python -m modreg serve --ontology
ontologies/ARSO --basyx http://localhost:8081 --discover`, port 8090) and the agents (`python -m
lineagents --aas http://localhost:8081 --mqtt localhost:1883`). The secrets are in `deploy/aas/.env`;
never commit them.

## An edge device as a module

Any 64-bit Linux device with GPIO can become an IEC 61499 module; the installer is made and tested for
a Raspberry Pi 4 or 5. Run one command on the device, as a user with sudo:

```bash
curl -fsSL https://raw.githubusercontent.com/AAU-AASPIRE/forte-runtime/main/install.sh | bash
```

It installs Docker if it is missing, starts FORTE (with every module's block types) in a container that
comes back after a reboot, gives it the GPIO lines and the hardware PWM channels (reboot once for
them), and keeps the clock across restarts (`fake-hwclock`, for devices without a battery-backed
clock). Running it again updates FORTE and keeps the program.

| On the device | |
| --- | --- |
| `~/forte` | The container (`docker compose ps`, `logs -f`): host network, the GPIO chip, the PWM channels |
| `~/forte/boot/forte.fboot` | The module's program, loaded at every start |
| port 61499 | FORTE's management protocol: no login, keep it on a trusted network |
| port 4840 | The module's OPC UA server, announced by mDNS |
| port 8088 | The manifest: the profiles of the module's AASs, for discovery |

From a workstation, over SSH (the device's address and login come from the module spec's `pi` target,
or `--host` and `--user`):

```powershell
python deploy/pi.py install --spec <module-spec.yaml> --forte forte-runtime/bin/forte-aarch64
python deploy/pi.py module --spec <module-spec.yaml>    # the program as the boot file, FORTE restarted
python deploy/pi.py status --spec <module-spec.yaml>
python deploy/pi.py log --spec <module-spec.yaml>
```

On a Raspberry Pi 5 the PWM channels are numbered differently (GPIO18 is channel 2); set `board: pi5`
in the spec's target. Step by step: [deploy a module to an edge device](../how-to/raspberry-pi.md).
