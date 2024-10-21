# Eli's Barn

the barn is old and smells of old hay and oddly dissolution

the floor is dirt and trampled dried horse shit scattered with straw and broken bottles

the smell is not unpleasent and reminds you faintly of petrol and old socks

```yaml
roomType: "barn"
```

## an old wooden barn door, leads south

```yaml
direction: South
type: "door"
material: "wood"
```

### actions:

#### [the door, closes with a creak](bensons-plain.md)

## a dusty window set at chest height in the west wall

```yaml
direction: West
type: "window"
material: "glass"
```

### actions
<!-- this implies that the window is closed and not broken -->
<!-- i.e. when it gets opened by chaining to break -->
<!-- the following description will be generated -->
#### [the window, now broken, falls open](elis-forge.md)

```yaml
type: "open"
enabled: false
dBit: false
revertable: false
```

<!-- the break action when triggered generates the following description -->
<!-- needs to manually linked to the open action in the config -->
#### the window, smashes, glass flies everywhere, very very satisfying

```yaml
type: "break"
affectsAction:
  actionID: TODO?
```

## a wooden trap door, is set in the floor leading downwards

```yaml
direction: Down
type: "trapdoor"
material: "wood"
```

### actions

#### [the trap door, opens with a bang releasing a small puff of something troubling](elis-basement.md)

```yaml
type: "open"
enabled: false
dBit: false
revertable: true
```

## a large dry bale of hay

### actions

#### the hay bursts into blue, yellow and orange flames with a speed and a heat so intense that you jump back loosing some eyebrows and gaining a small bit of wee

```yaml
type: "burn"
enabled: false
```

#### the hay soaks up the volatile liquid with gusto, the air smells potent

```yaml
type: "soak"
enabled: false
```
