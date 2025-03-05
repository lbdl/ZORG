<p align="center">
  <h1 align="center">The Oruggin Trail</h1>
</p>
<p align="center">
A Dojo based Zork inspired composable fully onchain text adventure engine. 
Begun designed aesthetised and largely entorely written by me `itrainspiders | lbdl`
(with recently a lot of help on the front end)

This is a large scale and complex art project around the fun that is a fully 3d, technicolor, smello-vision, black and white (well green mainly) text adventure.
It is intended to be  build upon by others and endlessly explorable, assuming you can be arsed to solve the puzzles.

Please feel free to enjoy or don't. We don't care! (much)
</p>
<p align="center">
Welcomew to the best worst game ever where you can pit yourself against not only a onchain NLP parser but ehatever stories
myself or yourselves can come up with. 
</p>

<p align="center" style="max-width: 50%;">
    <img src="https://github.com/ArchetypalTech/TheOrugginTrail/assets/983878/b90bcc55-2ba1-4564-94e1-d08184c1e49c"/></a>
</p>

## ⚡ Setup

#### 📦 Install the repo with [Bun](https://bun.sh)

Clone the repository, then install dependencies with [Bun](https://bun.sh)

```bash
bun install
```

### 💕 Quickstart installer:
Automated installer for installing [scarb](https://github.com/software-mansion/scarb) and [dojo](https://book.dojoengine.org/getting-started#install-using-asdf) using [asdf](https://asdf-vm.com/) and [homebrew](https://brew.sh/).

```bash
bun run quickstart
```

### 🕹️ Run development mode:

```bash
bun run dev
```

### 🔧 Manual dependency installation:

```bash
brew install asdf
asdf plugin add scarb
asdf plugin add dojo https://github.com/dojoengine/asdf-dojo

asdf install scarb <version>
asdf install dojo <version>
```

### 📦 Packages

This is a monorepo containing the following packages:

| **Package** | **Description**                               |
| ----------- | --------------------------------------------- |
| `client`    | Game client                                   |
| `contracts` | Dojo contracts        |
| `room-generator`     | JSON based utility for room generation   |

![ad_2_final](https://github.com/ArchetypalTech/TheOrugginTrail/assets/983878/b90bcc55-2ba1-4564-94e1-d08184c1e49c)
