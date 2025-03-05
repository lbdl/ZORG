<p align="center">
  <h1 align="center">ZORG</h1>
</p>

<p align="center">
The BEST and WORST game ever made. a 3d technicolor, smello-vision game engine in black and white (mainly green) text. Wahay!
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

![ad_1_final](https://github.com/user-attachments/assets/149eafd8-c67e-4374-9eb2-9aa5692e3121)
