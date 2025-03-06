<p align="center">
  <h1 align="center">ZORG - an onchain ever world that no one asked for</h1>
</p>

<p align="left">
The BEST and WORST game ever made. A <code>3d</code>, <code>technicolor</code>, <code>smello-vision</code> game engine in black and white (mainly green) text. Wahay!. Hours of fun (for 10 minutes). Product may cause virginity.
</p>

<p align="left">
The project was inspired by playing adventure games as a kid and being fascinated with them. Infocom had a brief period of making some great games that have largely been forgotten and blockchains offer a means of pratical world permanance. The engine and initial game are intended to be a kind of world sim but in text. Yes now you too can play a frustrating game where you have to figure out to to get to the next chapter. You can smell the roses and burn things to the ground. Leave trash round and shout into a void. You can play the game with others, lock them in rooms only you have the keys to and then wait for them to die. All this an possibly more.

The idea is that anyone can extend the worlds that are deployed. Im working on it (and multiplayer) right now is some one breaks something then the next player will see that broken something. This is kind of fun but might get tiresome. Working on it.

There are no solid deploys yet but you can run it locally.

There is a rudimentary adeventure here that you can play through that will be deployed somewhere.

See more at my site itrainspiders.com/whoreallycares

There is a bunch of text on the whys and why nots on my substack

This is the `dojo` version. There is also a `MUD` version.

There is also a fork of the project that is being worked on by AT and myself but this version is more canonocal.

Enjoy or don't !

Love You.
</p>

![ad_1_final](https://github.com/user-attachments/assets/149eafd8-c67e-4374-9eb2-9aa5692e3121)

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

