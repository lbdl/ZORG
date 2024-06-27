# TheOrugginTrail
A MUD (and eventually also Dojo, World Engine, and who-knows) based Zork-like experiment in fully onchain text adventures, onchain games framework interoperability, and the engines that drive them.
What lies ahead, is anyone's guess...

![ad_2_final](https://github.com/ArchetypalTech/TheOrugginTrail/assets/983878/b90bcc55-2ba1-4564-94e1-d08184c1e49c)



This project is a test-case for taking a zork-like text adventure engine and reimagining it in onchain gaming engines and frameworks like MUD, Dojo, and World Engine... and from there seeing if interesting interoperability between the engines can be connected and experimented with. This will also give an opportunity to see if any of the differences and affordances between frameworks and onchain game engines generate varied or new gameplay paradigms and directions.

We are porting / reinterpreting the MIT Zork design and architecture for text adventure engines onchain, this model eventually became the base for Infocom games and such favoured classics as Commodore64's The Hitchikers Guide To The Galaxy, one of the most ambitious and complex text adventures ever made. To get a primer and learn more about the engine and explore it's history and and the engineering principles under the hood please read these resources:

https://mud.co.uk/richard/zork.htm

https://github.com/MITDDC/zork

https://medium.com/swlh/zork-the-great-inner-workings-b68012952bdc

This Zork-like engine will be piloted by a text adventure called the O'ruggin Trail.

WARNING: attempting a crossing to the frontiers of crypto country ultimately always results in horrible death... physical, moral, ego, or otherwise.

Your pre death checklist:

it's a cairo/strknet/rust project

it uses the Dojo Frameowrk so you'll need a working install of that tooling.
[dojo setup](https://book.dojoengine.org/getting-started)

Your pre death checklist:

You will need to pull the submodule containing the cairo code, either:

### TheOrugginTrail-DoJo
`git clone --recurse-submodules git@github.com:ArchetypalTech/TheOrugginTrail-DoJo.git`

or assuming you cloned this without the `--recurse-submodules` flag

`git submodule init && git submodules update`

### 
it's a cairo/starknet/rust project

it uses the Dojo Framework so you'll need a working install of that tooling.

the best way to do this is using `asdf`
[asdf getting started](https://asdf-vm.com/guide/getting-started.html)

install the dojo stuff you need using asdf [dojo asdf](https://book.dojoengine.org/getting-started#install-using-asdf)
that should give you the dojo-plugin.

now install dojo, ND you need the dojo-plugin installed by the above link for this to work.
```shell
asdf install dojo 0.7.2
```

you also need `scarb`
```shell 
asdf install scarb 2.5.4 
```

you should now have the right versions of the tools installed and you can check by running

```shell
asdf current
```

at the root of the repo.

you should see:
```shell
dojo    0.7.2   some/path/...
scarb   2.5.4   some/path/...
```

it will also say no version set for starknet-foundry but this seems not to matter.

now prepare to die from __fun__!


### running locally for test

from the root of the project `pnpm deploy:local`

if you want to monitor the backgrounded processes use `mprocs`

so from the output of the above command look for the 2 l_path's and then:

`mprocs "tail -f <l_pathForKatana>" "tail -f <l_pathForTorii>"` that will tail both logs into your terminal.

Then call the output contract


``` shell 
sozo execute --manifest-path ./tot-dojo/Scarb.toml the_oruggin_trail::systems::outputter::outputter updateOutput --calldata str:"foo"
```

__NOTE__ if you are running in the root then you will need the `--manifest-path`
now prepare to die from __fun__!
