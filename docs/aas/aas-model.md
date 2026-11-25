# aas-model

<span class="pillar aas">AAS</span> The AAS model in Python (pydantic): the types every product,
process and resource AAS is an instance of, their submodels, and the generator that makes the classes
from submodel templates. Repository [aas-model](https://github.com/AAU-AASPIRE/aas-model).

<figure markdown="span">
  [![The product, process and resource AAS types side by side with their submodels, and below the five
  steps from a template to a published AAS](../figures/aas-model.png)](../figures/aas-model.png)
  <figcaption>The three types and their submodels (top), and how a type is made and used (bottom):
  templates, aas-model's generator, the classes, a profile, the AAS.</figcaption>
</figure>

## The types

| Type | Asset kind and type | Submodels |
| --- | --- | --- |
| `Product` | Type, `.../Product` | Nameplate, Hierarchical Structures (the bill of material), Process Parameters (IDTA 02031), Capability Description (required), Production Sequence (the recipe) |
| `Process` | Type, `.../Process` | Process Information, Bindings, Validation |
| `Module` | Instance, `.../Resource/Module` | Nameplate, Hierarchical Structures (its components), Asset Interfaces Description (one OPC UA server), Asset Interfaces Mapping Configuration, Skills, Capability Description (offered), Variables |
| `Component` | Instance, `.../Resource/Component/<Kind>` | Skills: its primitives, which its module carries out |
| `ProductionSystem` | Instance, `.../Resource/System` | Hierarchical Structures (its modules); Variables with the coordinates |

`Module`, `Component` and `ProductionSystem` are aas-model's `Resource` with the resource ontology's
submodels added: a module is a resource in the product-process-resource sense. A submodel a kind does
not have is left out.

What AASPIRE changes in the IDTA templates:

- **Capability Description (IDTA 02020):** a capability is realized by a skill of the same AAS or a
  component's (a model reference), a property is the module's variable it is (`SameAs`), a
  constraint is an expression (`BasicConstraint`).
- **Asset Interfaces Description:** OPC UA, with aas-model's own actions and events.
- **Skills, Parameters:** ARSO's own submodels, which have no IDTA template; their templates are
  generated from the ontology.

## From a template to an AAS

1. **Templates** (JSON): IDTA's and AASPIRE's, with semanticIds, idShorts and cardinalities.
2. **Generator** (`scripts/lab_generate.py`): pydantic classes from each template.
3. **Classes**: `aas_model.submodel_templates.*` and the types above.
4. **Profile**: an AAS as the pydantic dump of its type, without what the type says anyway. You write
   it, or a tool makes it (`modreg profile` from a module spec).
5. **AAS**: built from the profile by the [registration service](../integration/registration.md),
   checked against the [ontologies](ontologies.md), published to the AAS server.

ARSO's own templates are generated from the ontology into aas-model, so the ontology, the templates
and the classes cannot drift apart; a test fails when the committed templates no longer match it:

```powershell
python -m modreg generate --ontology ontologies/ARSO      # from the workspace folder
```

## Use it

Write a profile for each AAS, or let `modreg profile` make one from a module spec, then build the
AAS from it:

```powershell
python -m pip install -e aaspire-tools          # the tools, with aas-model, the BaSyx SDK and rdflib
python -m modreg profile aseptic-line/cell/modules/<module>.yaml --out profiles   # the module's and its components' profiles
python -m modreg build profiles/<Module>AAS.json --out aas                      # the AAS the profile describes
```

aas-model documents its own types in `docs/lab-aas.md` and each submodel in `docs/lab-submodels/`.
It loads the MQTT message schemas from GitHub when it is imported, unless `MQTT_SCHEMAS_DIR` names a
local copy.
