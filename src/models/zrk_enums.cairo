/// Biome types
/// used later to generate text and seed ascii art
/// type things
#[derive(Serde, Copy, Drop, Introspect)]
enum BiomeType {
    None,
    Forest,
    Tundra,
    Arctic,
    Desert,
    Temporate,
    Faery,
    Demon,
}

/// Room Types 
/// used by the description libs to autogen
/// description strings by composition rather
/// than being hardcoded
#[derive(Serde, Copy, Drop, Introspect)]
enum RoomType {
    None,
    WoodCabin,
    Store,
    Cavern,
    StoneCabin,
    WoodCabin,
    Fort,
    Room,
    Plain,
} 

/// Material Type
/// used later in the LOOK system and others to compose
/// description strings and to determine base functionality
#[derive(Serde, Copy, Drop, Introspect)]
enum MaterialType {
    None,
    Wood,
    Dirt,
    Stone,
    Flesh,
    Glass,
    IKEA,
    Iron,
    Shit,
    Mud,
}

/// Direction Type
/// used by the direction syetm to determine movement
/// and ofc the direction of things in the world
#[derive(Serde, Copy, Drop, Introspect)]
enum DirectionType {
    None,
    North,
    East,
    South,
    West,
    Up,
    Down,
    Left,
    Right,
}