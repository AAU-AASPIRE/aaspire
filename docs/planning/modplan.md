# modplan

<span class="pillar planning">Planning</span> Plans a new composite skill for a module from its
Capability Description, checks the skills the module has, and finds what it could carry out after a
reconfiguration. A package of [aaspire-tools](https://github.com/AAU-AASPIRE/aaspire-tools).

<figure markdown="span">
  [![The module's AAS with its Capability Description and Skills on the left; modplan's four steps from
  a requirement in the middle; the planned skill SkillX as four steps and modsync creating it on the
  right](../figures/modplan.png)](../figures/modplan.png)
  <figcaption>From a requirement to a described skill: read the domain, plan, lift the plan into a flow,
  describe it in the Skills submodel. modsync then builds it on the running module.</figcaption>
</figure>

## How it plans

The input is a **requirement**: a capability the module offers, the values of its properties (say
`Amount = 2.0`), and the results asked for (say `Measured`). It comes from a product's step, an
engineer, or an agent that wants to bid.

1. **Read** the domain from the module's AAS: the state variables (the properties of the components
   and of the product), the components' capabilities as actions with what they need, do and keep,
   and the rest state the module's Reset procedure leaves.
2. **Plan** on GTPyhop, a hybrid of HTN and goal regression: the goals are the capability's
   postcondition with the requirement's values, what the results need, and the rest state. A goal is
   reached by an action that sets it; the action's preconditions become goals in turn. A composition
   the module states for the capability is tried first; the first plan found is taken.
3. **Lift** the plan into a flow: two steps are ordered when they use the same component or one changes
   what the other needs, changes or keeps; the series-parallel form of that order is the flow, so
   steps on different components run in parallel where nothing orders them.
4. **Describe** it: the flow, the results from the steps that measured them, and the module's Stop
   procedure as the stop flow, written into the Skills submodel as the Skill Editor saves a skill,
   with `Deployment = Described`. `modsync reconfigure` then creates it online.

It also:

- **checks** a composite skill: its flow is run through the states, and a precondition that does
  not hold is reported with the steps that would make it hold;
- **discovers** what the module can carry out: for each process capability of the vocabulary, the
  values its properties can take and whether a plan exists;
- **exports** the same problem for standard planners: PDDL 2.1 with numbers (ENHSP) and HDDL (Aries).
  Their plans, carried out by the domain's own semantics, reach what was asked for.

Planning a skill of a handful of steps takes under a millisecond on a PC, reading the domain from the
AAS about one; the same cases through ENHSP and Aries take tens to hundreds of milliseconds.

## Use it

Point it at a folder of AAS files or at an AAS server (`http://<host>:8081`):

```powershell
python -m pip install -e "aaspire-tools[planners]"   # GTPyhop is always in; [planners] adds ENHSP and Aries
python -m modplan domain <aas>                        # what the planner reads: capabilities, constraints, rest state
python -m modplan check <aas> --skill <Skill>         # a composite skill run through the states
python -m modplan discover <aas>                      # what the module can carry out, skill or no skill
python -m modplan plan <aas> --capability <Capability> --value <Property>=<value> --result <Result> --write
python -m modplan export <aas> --capability <Capability> --value <Property>=<value> --as hddl --out planning/
python -m modsync reconfigure <aas> --host <FORTE's host>   # build the described skill online, and record it
```

`plan --write` describes the skill in the AAS it came from; nothing is built until modsync builds it.
The registration service offers the same planning to the Skill Editor (`POST /plan/<module>`).

## What it assumes

A module's state is a handful of properties of its components and of one product, each a known
value, and a skill starts and ends at rest. Not modelled: relations between many objects (a
transport system's carriers), arithmetic beyond adding and comparing, and time.

Read further: [composing skills from capabilities](../reference/skill-planning.md),
[how the tools work](../reference/tools.md), section 5.
