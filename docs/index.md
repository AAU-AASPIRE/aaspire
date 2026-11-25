# AASPIRE

**AAS-based Planning, Integration, Reconfiguration and Execution.** Plug and produce with the Asset
Administration Shell.

AASPIRE is a framework for building production lines from modules that describe themselves. Every
resource, product and process gets an Asset Administration Shell (AAS), and the AAS becomes the one
place where you say what a module offers, what a product needs and how the two meet. The tools read
those AASs to plug a module in, to plan what it should do, to change its program while it runs and to
run the line. A module is an IEC 61499 program on Eclipse 4diac FORTE, on an edge device or a PC, or any
other controller that offers the same interface over OPC UA.

<figure markdown="span">
  [![The framework: the apps on top; the AAS server with the product, process and resource AASs in the
  middle; Planning, Integration, Reconfiguration and Execution around it; your line's modules
  below](figures/framework.png)](figures/framework.png)
  <figcaption>The AAS server holds the models every part reads and writes. Planning decides what to do,
  Integration plugs a resource in, Reconfiguration changes a running module, Execution runs the line. Click
  a figure to see it at full size.</figcaption>
</figure>

## The pillars

| Pillar | What you do with it | Parts |
| --- | --- | --- |
| <span class="pillar aas">AAS</span> | Describe what a resource, a product and a process are | [aas-model](aas/aas-model.md), [the ontologies](aas/ontologies.md) |
| <span class="pillar planning">Planning</span> | Decide what to do from capabilities | [modplan](planning/modplan.md); a line planner of your choice |
| <span class="pillar integration">Integration</span> | Plug a resource in: register, discover, connect, map its data | [registration service](integration/registration.md), [DMP](integration/dmp.md), [modlink](integration/modlink.md) |
| <span class="pillar reconfiguration">Reconfiguration</span> | Change a running resource from its AAS | [modsync](reconfiguration/modsync.md), [skill library](reconfiguration/skill-lib.md), [management library](reconfiguration/mgmt.md), [FORTE runtime](reconfiguration/runtime.md) |
| <span class="pillar execution">Execution</span> | Produce: run a product's steps on the line | [line agents](execution/agents.md), [planar controller](execution/planar-controller.md); or a behaviour tree |

Three more hold everything together: <span class="pillar interfaces">Interfaces</span>, the [apps in
the web UI](interfaces/web-ui.md); <span class="pillar deployment">Deployment</span>, the [server stack
and the modules on their devices](deployment/deploy.md); and <span class="pillar lines">Lines</span>,
how [a line of your own](lines/aseptic-line.md) is laid out, with an aseptic filling line as the worked
example.

## The idea in one paragraph

A module is delivered as two things: an IEC 61499 program that follows a small set of
[module rules](reconfiguration/index.md), and an AAS that says what the program offers. From those two
alone, without the files the module was generated from, the tools can verify the module, operate it and
change it online. A new skill can be planned from the module's own capability model and created on the
running module the same way. Everything above the module (the orchestrator, the apps, the agents) talks
to it only through its AAS and its OPC UA interface, so any of them can be swapped.

## One line, any orchestrator

Only the orchestration differs between ways of running a line. You can run it **centrally**, where a
planner makes a policy for the order from the AASs and a behaviour tree runs it, or **multi-agent**,
where a product agent per unit asks for one step at a time and the resources' agents bid. Everything
below the orchestration is shared: the models, the modules, the way a skill is run, the integration and
the reconfiguration. [Execution](execution/index.md) says more.

## Where to start

- **New to it:** read this page, then a pillar's page; the [glossary](overview/glossary.md) has the words.
- **See a module run:** [run a module on a PC](how-to/simulation.md), with its IO simulated.
- **Put one on hardware:** [deploy a module to an edge device](how-to/raspberry-pi.md).
- **Plug it in:** [register a module and publish a line](how-to/register.md).
- **Change one while it runs:** [change a skill online](how-to/change-a-skill.md).
- **Build your own line:** [a line's repository](lines/aseptic-line.md), then
  [building skills and equipment](reference/building-skills.md).
- **Find the code:** [repositories](overview/repositories.md) maps every part to its repository.
