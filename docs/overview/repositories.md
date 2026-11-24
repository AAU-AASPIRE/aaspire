# Repositories

AASPIRE is a set of repositories in the GitHub organization
[AAU-AASPIRE](https://github.com/AAU-AASPIRE), one per part, grouped by pillar. Until 24 November 2026
they shared one repository (AAUSmartProductionLab/iec61499-mgmt-py); each part was copied out with its
history.

<figure markdown="span">
  [![The repositories of AAU-AASPIRE by pillar, and where each came from](../figures/repository-map.png)](../figures/repository-map.png)
  <figcaption>The repositories by pillar, in the pillars' colours, and where each came from.</figcaption>
</figure>

| Pillar | Repository | What it is | Page |
| --- | --- | --- | --- |
| AAS | [ontologies](https://github.com/AAU-AASPIRE/ontologies) | ARSO, APSO, AProSO, PPRL and the vocabulary | [Ontologies](../aas/ontologies.md) |
| AAS | [aas-model](https://github.com/AAU-AASPIRE/aas-model) | The lab's AAS model: types, templates, instances (a placeholder until it merges upstream) | [aas-model](../aas/aas-model.md) |
| Planning | [modplan](https://github.com/AAU-AASPIRE/modplan) | Plans a new skill from a module's capabilities | [modplan](../planning/modplan.md) |
| Integration | [modreg](https://github.com/AAU-AASPIRE/modreg) | Builds, checks, derives and publishes the AASs; the registration and skill service | [Registration service](../integration/registration.md) |
| Integration | [modlink](https://github.com/AAU-AASPIRE/modlink) | Runs a module's skills over OPC UA from its AAS | [modlink](../integration/modlink.md) |
| Integration | [aas-camel-dmp](https://github.com/AAU-AASPIRE/aas-camel-dmp) | The data-mapping processor (Tristan's, moving here) | [DMP](../integration/dmp.md) |
| Reconfiguration | [modsync](https://github.com/AAU-AASPIRE/modsync) | Keeps a running IEC 61499 program in step with its AAS | [modsync](../reconfiguration/modsync.md) |
| Reconfiguration | [iec61499-skill-lib](https://github.com/AAU-AASPIRE/iec61499-skill-lib) | ModLib and modgen | [Skill library](../reconfiguration/skill-lib.md) |
| Reconfiguration | [iec61499-mgmt-py](https://github.com/AAU-AASPIRE/iec61499-mgmt-py) | The client of FORTE's management protocol | [Management library](../reconfiguration/mgmt.md) |
| Reconfiguration | [forte-runtime](https://github.com/AAU-AASPIRE/forte-runtime) | FORTE for the PC and the Pi, our patches, the Pi installer | [FORTE runtime](../reconfiguration/runtime.md) |
| Execution | [AAS-MAS](https://github.com/AAU-AASPIRE/AAS-MAS) | The multi-agent orchestrator (package `lineagents`) | [Line agents](../execution/agents.md) |
| Execution | [planar-controller](https://github.com/AAU-AASPIRE/planar-controller) | The planar table's controller | [Planar controller](../execution/planar-controller.md) |
| Execution | [module-py](https://github.com/AAU-AASPIRE/module-py) | A module run in Python (modpy), for the robots | |
| Interfaces | [basyx-aas-web-ui](https://github.com/AAU-AASPIRE/basyx-aas-web-ui) | The BaSyx web UI, our fork: Process Sequence, the skill editor, the Configurator | [Web UI](../interfaces/web-ui.md) |
| Deployment | [deploy](https://github.com/AAU-AASPIRE/deploy) | The lab stack, the Pi tooling, the bench tools | [Deployment](../deployment/deploy.md) |
| Lines | [aseptic-line](https://github.com/AAU-AASPIRE/aseptic-line) | The lab's line: specs, generated programs, example AASs, evaluation | [The aseptic line](../lines/aseptic-line.md) |
| Main | [aaspire](https://github.com/AAU-AASPIRE/aaspire) | This site, the repositories' map, the workspace | [This site](../how-to/this-site.md) |

## How they come together

- **Side by side, no submodules.** For development every repository is cloned into one folder
  (`AAU-AASPIRE/<repository>`) by `aaspire/workspace/clone.ps1` (or `clone.sh`), which also installs the
  Python parts editable. Each finds the others beside it: the tools the ontologies, modgen the line's
  specs, the Pi tooling FORTE, the lab stack the DMP and the web UI for its images.
- **Dependencies by repository.** Each Python part declares the others it needs as Git dependencies
  of the organization's repositories; the lab stack's images are built from the folder that holds them.
- **Versions**: the parts by SemVer, `aaspire` by date (`2026.11` with the CIRP paper, `2027.01` with
  the demo).

Pinned, not the lab's: Eclipse 4diac FORTE, BaSyx's images, unified-planning, the IDTA templates.

## The working notes

The notes the work was done by (the design log, the plans, the decisions, onboarding) are in the
private repository `aaspire-internal`, for the organization's members. This site is written from them
for a reader who was not there; the reference documents (the models, the module rules, the tools) are
its [Reference](../reference/aas-models.md) section.
