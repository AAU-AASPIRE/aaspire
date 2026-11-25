# Management library

<span class="pillar reconfiguration">Reconfiguration</span> `iec61499_mgmt`: Eclipse 4diac FORTE's
management protocol in Python, and what is built on it: a 4diac system flattened into commands, boot
files, a type library with FORTE's type hashes, plans from one program to another, and read-back.
Use it when you need to talk to a FORTE from Python. Repository
[iec61499-mgmt-py](https://github.com/AAU-AASPIRE/iec61499-mgmt-py).

<figure markdown="span">
  [![What the library reads on the left, its modules in the middle with the protocol below them, and
  FORTE's management port and boot file on the right](../figures/mgmt.png)](../figures/mgmt.png)
  <figcaption>A 4diac system becomes commands and a boot file; plans and read-back go through one typed
  client to FORTE's port 61499.</figcaption>
</figure>

## The modules

| Module | Does |
| --- | --- |
| `protocol` | `Command`: one typed request (`create_fb`, `delete_fb`, `connect`, `disconnect`, `write`, `read`, `start`, `stop`, `kill`, `query_fbs`, `query_connections`, `query_type`). `Client`: one TCP connection, one request at a time; an error answer raises `ManagementError`; nothing is retried |
| `sysfile` | A `.sys` application flattened: untyped subapplications become dotted names, connections through their pins are resolved to the blocks they reach, the resource's START links kept |
| `bootfile` | The commands as FORTE's boot file: the resource, the blocks inside the application's container (as the 4diac IDE deploys, so the IDE can monitor the program), values, connections, start |
| `typelib` | `types.json`: each type's interface from its `.fbt`, its hash from the running FORTE |
| `planner` | The ordered commands from a current to a desired network; no sockets, no restarts implied |
| `verify` | A resource read back and compared with what was wanted |

## Talking to FORTE

```python
from iec61499_mgmt.protocol import Client, Command

with Client("<module host>", 61499) as forte:
    fbs = forte.execute(Command(op="query_fbs", resource="RES")).fbs        # every block: name, type
    src = "<Application>.Module.State"
    state = forte.execute(Command(op="read", resource="RES", source=src)).read_value(src)
```

A program runs inside its application's container, so a name is `<Application>.<Block>.<Pin>`; the
resource's own `START` block is outside. FORTE's port 61499 has no login: keep it on a trusted
network only. Two things to avoid: deleting a resource with a GPIOChip in it (FORTE 3.3 crashes), and
killing a resource that does not exist (FORTE shuts down). A program is replaced by a new boot file
and a restart.

```powershell
python -m iec61499_mgmt boot --system <Project>/<Project>.sys --application <Application> --out forte.fboot
python -m iec61499_mgmt types --types-dir "<Project>/Type Library" --host 127.0.0.1 --out types.json
python -m iec61499_mgmt plan --current current.json --desired desired.json --library types.json --out plan.json
python -m iec61499_mgmt schema network --out network.schema.json   # the JSON contracts: network, patch, plan, library
```

Used by [modsync](modsync.md) (reading and changing online), `deploy/pi.py` (boot files) and modgen's
tests.
