# A line's repository

<span class="pillar lines">Lines</span> A line built with AASPIRE lives in a repository of its own: the
module specs you write, the programs generated from them, the simulators, the AASs of its resources,
products and processes, and the tests. This page shows how to lay one out, with the
[aseptic-line](https://github.com/AAU-AASPIRE/aseptic-line) repository, an aseptic filling line, as the
worked example. Start your own line by copying its layout.

<figure markdown="span">
  [![The folders of a line's repository: modules, control and sim on the left; the line's AASs and the
  evaluation in the middle; the AAS server, FORTE and the tests on the right](../figures/aseptic-line.png)](../figures/aseptic-line.png)
  <figcaption>Specs become programs (control/) and AASs (examples/); the simulator stands in for the
  hardware; an optional evaluation times each change online and by a restart.</figcaption>
</figure>

## The folders

| Folder | Holds | You |
| --- | --- | --- |
| `modules/` | One module spec per module (`<module>.yaml`): equipment, IO per target, primitives, skills, procedures | write |
| `control/` | The generated 4diac projects, one per module, with the layouts arranged in the IDE | generate with `python -m modgen`, then arrange |
| `sim/` | `module_sim.py`: a module's IO simulated over Modbus; `run_module.py`: simulator, FORTE and the module at once; `module_ua.py`: a small OPC UA client | reuse as is |
| `examples/` | `example_line.py`: every AAS of the line built with modreg (the line, its transport, the modules and their components, the products, a process each), each process checked (`plan_check.py`), published with `--publish` | write |
| `eval/` | Optional: scenarios that time each change online and by a restart, planners compared | write if you evaluate |
| `tests/` | The modules live on FORTE, on a device, through the DMP; the line's AASs built and checked | write |

## Build a line, step by step

1. **Specify each module** in `modules/<module>.yaml`
   ([building skills and equipment](../reference/building-skills.md)).
2. **Generate** the programs: `python -m modgen` (with `MODGEN_CELL` naming your line's folder), and
   build a FORTE with their block types ([FORTE runtime](../reconfiguration/runtime.md)).
3. **Run each module on a PC** with its IO simulated, and test it
   ([run a module on a PC](../how-to/simulation.md)).
4. **Describe the line**: a script like `example_line.py` that builds the line's, the modules', the
   products' and the processes' AASs from profiles, and checks every process.
5. **Deploy** the modules to their devices ([deploy to an edge device](../how-to/raspberry-pi.md)) and
   **publish** the AASs ([register a module, publish a line](../how-to/register.md)).

In the example:

```powershell
cd aseptic-line
python cell/sim/run_module.py cell/modules/<module>.yaml           # a module with simulated IO
python cell/examples/example_line.py --out aas --publish http://localhost:8081
python cell/eval/scenarios.py --forte <forte.exe> --runs 5         # the evaluation
```

## The example line

The aseptic line fills pharmaceutical containers. A planar motor table carries them on shuttles
between the modules: filling (a needle on a linear axis, a pump, a scale), stoppering, capping,
inspection, and loading and unloading by robots. Its products are a vial, a prefilled syringe and a
cartridge, each with its recipe and its process on the line. The pages in the
[Reference](../reference/aas-examples.md) section go through it in depth: its AASs, its modules and
their hardware, and the filling program block by block.
