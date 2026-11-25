# Execution: running the line

<span class="pillar execution">Execution</span> A product is made by running its recipe's steps on the
line's resources. Which resource does which step, and when, is the orchestrator's decision. AASPIRE
keeps everything below the orchestrator the same, so you can choose how the line is orchestrated, and
change your mind later.

| Orchestrator | How it decides | In AASPIRE |
| --- | --- | --- |
| **Centralized** | A planner makes a policy for the order (PDDL, from the AASs); a behaviour tree runs it | bring your own planner and behaviour tree; they read the same AASs |
| **Multi-agent** | A product agent per unit asks for one step at a time; the resources' agents bid; the product agent chooses | [line agents](agents.md) (`lineagents`) |

## What every orchestrator shares

| Shared | What it is |
| --- | --- |
| The models | The resource, product and process AASs: skills, capabilities, interfaces, variables; the product's recipe. Every orchestrator starts from the same order |
| The modules | ModLib's behaviour in IEC 61499: occupation, the PackML module state, each skill's state machine, the skills as OPC UA methods |
| Running a skill | The same five steps, by the same route (below) |
| Integration | Registration and discovery; the DMP |
| Reconfiguration | A planned or described skill created online by modsync before it runs |
| The line | The same modules, the transport, the simulators |

## Running a skill

Every orchestrator runs a skill on a module the same way, straight over OPC UA
([modlink](../integration/modlink.md)) or through the AAS server and the [DMP](../integration/dmp.md).
If you write an orchestrator of your own, this is all it needs to do per step:

1. **occupy** the module with a session id: from then on only that session commands it;
2. **bring it to Execute** (Clear, Reset, Start, as its PackML state needs);
3. **start the skill** with its values; the module answers at once whether it accepts;
4. **wait for its end**: Succeeded, Failed or Aborted, with an error id and the results;
5. **release** the module.

Occupation is also the handover between orchestrators: whoever holds a module commands it, so a line
can pass from one orchestrator to another between orders, once every module is released.

## Comparing orchestrators

Because only the orchestration differs, two orchestrators can be compared fairly: run one scenario of
orders and events (a module failing, a rush order, a module plugged in) with each, and measure the time
to finish the orders, the reaction to a failure, the time until a module plugged in is used, and the
work to set each up.

## Machines that are not IEC 61499 modules

A robot or a transport system with its own controller joins the line by offering the same interface:
occupation, PackML states and skills over OPC UA, and an AAS. The
[planar controller](planar-controller.md) does this for a planar motor table; `modpy` in
aaspire-tools does it for a module written in Python.
