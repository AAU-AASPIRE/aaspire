# Line agents

<span class="pillar execution">Execution</span> `lineagents`: the multi-agent orchestrator. A product
agent per unit ordered walks its product's recipe and asks for one step at a time; a resource agent per
module and per transport bids for the steps its resource can carry out and carries out the steps it
wins. SPADE over XMPP, speaking the I4.0 language of VDI/VDE 2193. Repository
[AAS-MAS](https://github.com/AAU-AASPIRE/AAS-MAS).

<figure markdown="span">
  [![Orders starting a product agent per unit; the bidding between a product agent and the resource
  agents in four messages; how a resource agent reaches its module](../figures/agents.png)](../figures/agents.png)
  <figcaption>An order starts a product agent per unit; each step is bid for (call for proposals,
  proposal or refusal, acceptance, result); the winner creates the skill if it is only described and
  runs it through one of three executors.</figcaption>
</figure>

## The parts and where they run

| Part | Runs | Does |
| --- | --- | --- |
| A module | its own controller: FORTE and the module's program | Occupation, its states, its skills over OPC UA; announces itself |
| Its AAS | the AAS server | What it is and offers |
| **The manager** | the server (`python -m lineagents`) | A resource agent for every module the AAS server holds, started on the server's MQTT events and stopped when the AAS goes; the order agent |
| **The order agent** | in the manager | Takes an order (product, quantity) over XMPP or HTTP and starts a product agent per unit |
| **A product agent** | in the manager | Walks its product's steps: calls for proposals, chooses, has the product carried to the module, reports to whoever ordered |
| **A resource agent** | in the manager | Bids what its resource offers; creates a described skill first when its bid is accepted; runs the skill |

The agents run on the server, not on the modules' devices: a device runs the module's control program
and nothing that decides. The module stays what it is delivered as, an IEC 61499 program and an AAS,
and the agents stay replaceable.

## The bidding

For each step the product agent sends a **call for proposals** with the step's required capability to
every resource agent. Each answers with a **proposal** (the offered capability that covers the values,
the skill that realizes it, whether it is built or only described) or a **refusal**. A proposal is
binding: the resource refuses others, saying it is busy, until the product agent decides. The product
agent takes a proposal whose skill is built before one that needs a reconfiguration, has the product
carried to the module, **accepts** it and rejects the rest; the resource agent **informs** of the
result or of the failure. A failed step is asked for again of the others.

Custody decides who may carry a product: a resource holds a product from the Receiving it carried out
until the Releasing, and only the transport that holds a product moves it.

## Reaching the module

| Executor | How |
| --- | --- |
| `opcua` | Straight to the module's OPC UA server with [modlink](../integration/modlink.md): occupy, Execute, start, wait, release |
| `dmp` | The skill's Operation invoked at the AAS server; the [DMP](../integration/dmp.md) calls the module; the state read from InfluxDB |
| `simulated` | No module: the time a skill takes (tests, a demo without hardware) |

## Use it

```powershell
python -m pip install -e AAS-MAS
python -m lineagents --aas http://localhost:8081 --embedded                          # a resource agent per module
python -m lineagents --aas http://localhost:8081 --embedded --order <Product>AAS:3   # ... and three units
python -m lineagents --aas http://localhost:8081 --mqtt localhost:1883 --http 8095    # in the server stack (Prosody)
```

`--embedded` runs SPADE's own XMPP server in the process; in the server stack the agents use Prosody.
`--executor opcua|dmp|simulated` chooses how skills run; `--http` takes orders over HTTP too
(`POST /orders {"product": "<Product>AAS", "quantity": 3}`).

Start with `--executor simulated` to watch the bidding without any hardware, then switch to `opcua`
against [a module on a PC](../how-to/simulation.md).

Built: discovery to agent within seconds, bidding, transport with custody (on simulated shuttles), a
step that needs a reconfiguration. Still to come: a planned skill in a bid, failure handling, the
Orders app.
