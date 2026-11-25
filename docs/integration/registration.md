# Registration service

<span class="pillar integration">Integration</span> `modreg serve`: builds a resource's AAS from its
profile, checks it against the resource ontology, publishes it on the AAS server, and finds new
modules on the network by itself. A package of
[aaspire-tools](https://github.com/AAU-AASPIRE/aaspire-tools).

<figure markdown="span">
  [![A new module announcing its OPC UA server and serving its manifest; the service's five steps
  from Discover to Publish; the AAS server and those who read it](../figures/registration.png)](../figures/registration.png)
  <figcaption>A module is found (1), its profiles fetched from beside FORTE (2), built into AASs (3),
  checked against ARSO (4) and published (5). A profile can also be sent by hand.</figcaption>
</figure>

## What it does

1. **Discover** (`--discover`): FORTE announces its OPC UA server by mDNS when it starts; the service
   notices a server it does not know.
2. **Fetch** the module's manifest from beside FORTE (`http://<module>:8088/manifest.json`): the
   profiles of the module's AAS and of its components' AASs. Or a profile arrives by hand:
   `POST /profiles`, or `modreg register`.
3. **Build**: each profile is read into its aas-model type, and the AAS is made from it.
4. **Check** against ARSO, closed: a broken restriction refuses the module; `--strict` also refuses
   what the ontology does not describe.
5. **Publish** to the AAS server, with the offered capabilities derived from the skills. A profile
   registered again unchanged is not published again.

The service keeps each profile, its AAS and the integrator's record in its store folder (`--store`,
`registry/` by default).

## Its endpoints

| Endpoint | For |
| --- | --- |
| `POST /profiles`, `GET /profiles`, `GET /profiles/<id>[/profile\|/aas\|/registration]`, `DELETE /profiles/<id>` | Registering, reading and removing a resource |
| `POST /check/<module>` | The Skill Editor: is this skill buildable on this module? |
| `POST /plan/<module>` | The Skill Editor and the Planner's Match and plan: plan a skill for a requirement ([modplan](../planning/modplan.md)); written, the offered capabilities derived anew |
| `POST /match` | The Planner: which resources offer what a step requires, with the one matcher the agents and the plan check use (`modreg.match`) |
| `POST /capabilities/<module>` | The offered capabilities derived from the skills |
| `POST /process/<product>` | The Planner and the Configurator: the product's process AAS on a line, from the bindings, with the plan check's result |
| `GET /build/<id>`, `PUT /build/<id>` | The integrator's record of what was built |
| `GET /discovered`, `GET /health` | What discovery found; whether it runs |

## Use it

From the workspace folder, with the [server stack](../deployment/deploy.md) running:

```powershell
python -m pip install -e aaspire-tools
python -m modreg serve --ontology ontologies/ARSO --basyx http://localhost:8081 --discover   # on :8090
python -m modreg register <module-spec.yaml> --service http://localhost:8090 --check   # only check
python -m modreg register <module-spec.yaml> --service http://localhost:8090           # register
python -m modsync pull --host <module host> --register http://localhost:8090         # what runs on a module
```

`register` takes a profile (`.json`) or a module spec; `--target` picks the spec's target. `--register`
also works with `modsync describe`, `push` and `watch`: a module is then registered whenever it comes
online or changes.

!!! warning "A shared AAS server"
    If your organization runs a shared AAS server with live shells, an AAS with the same ids
    overwrites them. Try things on the [stack on your own PC](../deployment/deploy.md) first, and
    publish to a shared server only when its owners agree.

Read further: [the AAS models](../reference/aas-models.md).
