# Planning: deciding from capabilities

<span class="pillar planning">Planning</span> Planning decides what to do from what the AASs say:
what a product's steps require and what the resources offer. It happens at two levels, and both read
the same AASs.

| Level | Question | Planner | Reads | Gives |
| --- | --- | --- | --- | --- |
| **The line** | Which resource does which step of an order, and in which order? | A line planner, e.g. a FOND planner on PDDL | The resource AASs, the product's recipe | A policy, run as a behaviour tree by a centralized orchestrator |
| **A module** | The module offers the capability but has no skill for these values: which of its components' primitives, in which order? | [modplan](modplan.md): HTN with goal regression (GTPyhop) | The module's Capability Description | A new composite skill, described in the module's AAS, then created online by [modsync](../reconfiguration/modsync.md) |

A multi-agent orchestrator does the first by bidding instead of planning ahead
([line agents](../execution/agents.md)); a bid can rest on a skill that modplan plans and modsync
creates first.

## Capabilities as the planning domain

A module's Capability Description is enough to plan with, if you fill it in fully. Besides what the
module offers (a capability with its property ranges, realized by a skill), give what each of its
components' primitives can do, each with what it needs, does and keeps: preconditions, postconditions
and invariants as IDTA 02020 constraints. The vocabulary says what each kind of capability does
wherever it is used. A capability the module could offer after a reconfiguration is then found from
its AAS alone: offered now, offered after a reconfiguration (by which description), or not offered.

## The parts

| Part | What |
| --- | --- |
| [modplan](modplan.md) | Plans, checks and discovers a module's skills; exports to PDDL and HDDL |
| The Planner (web UI) | Matches a recipe's steps to the resources and binds them ([web UI](../interfaces/web-ui.md)) |

Read further: [composing skills from capabilities](../reference/skill-planning.md).
