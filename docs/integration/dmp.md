# DMP

<span class="pillar integration">Integration</span> The data-mapping processor, `aas-camel-dmp`: it
makes a published AAS run. An Operation invoked at the AAS server calls the module's OPC UA method,
and the module's values become rows in InfluxDB, without a configuration file of its own: the AASs
are its configuration. Java with Apache Camel 4, based on the Eclipse BaSyx DataBridge. Repository
[aas-camel-dmp](https://github.com/AAU-AASPIRE/aas-camel-dmp).

<figure markdown="span">
  [![The module's AAS with its interface description, mapping configuration, skills and variables; the
  DMP's four steps; the module, InfluxDB and the stack on the right](../figures/dmp.png)](../figures/dmp.png)
  <figcaption>The DMP builds its routes from the mapping configurations on the AAS server (1, 2), runs
  them (3) and follows the server's events, so a module published a moment ago is mapped (4).</figcaption>
</figure>

## How it works

1. **Discover**: at start, the DMP lists the Asset Interfaces Mapping Configurations (AIMC) on the AAS
   server by their semanticId and reads each submodel they reference once: an interface description
   whole, any other submodel only where it is referenced. Shells are never read.
2. **Compile**: each mapping becomes one bundle of Apache Camel routes. Transformations arrive as Lua
   in the AIMC and are compiled in memory; a referenced element's value type types the values.
3. **Run**: an Operation invoked at the AAS server calls the module's OPC UA method; the module's
   values are written to the time series the module's Variables name; every call is logged in the
   module's Log series.
4. **Follow** the server's events (MQTT or Kafka): an event that can change a mapping re-reads only the
   changed submodel and recompiles only what depends on it; unchanged mappings keep their routes.

A client therefore needs nothing but the AAS server to run a skill: an agent, a behaviour tree, a
script in any language.

## What your AAS needs

For the DMP to run a module, its AAS needs an Asset Interfaces Description (the OPC UA endpoint and
the browse paths), an AIMC that maps each Operation to an action and each property to a time series,
and a Variables submodel that names the series. AASs built by the
[registration service](registration.md) have all three.

## In the server stack

The DMP is built into the stack's `dmp` image and starts with BaSyx, InfluxDB and Mosquitto
([Deployment](../deployment/deploy.md)):

```powershell
python deploy/aas.py up                          # the stack, the DMP on :8085
python deploy/aas.py status <Module>AAS          # what the DMP made of a module's mappings, and why one does not run
python deploy/aas.py rows <Module>AAS            # the latest row of each of the module's series
```

Its own README describes every mapping it can run.
