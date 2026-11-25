# Register a module, publish a line

Put the AASs on an AAS server, where the apps, the agents and the DMP find them. Everything here runs
on your own PC, from the workspace folder.

!!! warning "Use your own server first"
    If your organization runs a shared AAS server with live shells, an AAS with the same id
    overwrites them. Work against the stack on your own PC, and publish to a shared server only when
    its owners agree.

## 1. The stack

```powershell
python deploy/aas.py up       # BaSyx (:8081), the web UI (:3000), the DMP, InfluxDB, Mosquitto, Prosody
```

The AAS environment keeps the AASs in memory: publish them again after a restart.

## 2. The registration service

```powershell
python -m modreg serve --ontology ontologies/ARSO --basyx http://localhost:8081 --discover
```

It listens on port 8090. With `--discover` it finds every module on the network whose FORTE announces
itself and registers it from the profiles the module serves.

## 3. A module by hand

```powershell
python -m modreg register <module-spec.yaml> --service http://localhost:8090 --check   # only check it
python -m modreg register <module-spec.yaml> --service http://localhost:8090           # register it
python -m modsync pull --host <module host> --register http://localhost:8090          # what runs, registered
```

`register` takes a module spec or a profile (`.json`). A profile that breaks a restriction of ARSO is
refused, with the reasons.

## 4. The whole line

Write one script that builds every AAS of your line from profiles, checks every process and publishes
them. The example line's script shows how:

```powershell
cd aseptic-line
python cell/examples/example_line.py --out aas --publish http://localhost:8081
```

It publishes the line, its transport, the modules and their components, the products, and the process
of each, every process checked first. Open `http://localhost:3000` to see them in the web UI, and the
Planner to bind a recipe.
