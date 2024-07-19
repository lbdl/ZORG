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
    Fort,
    Room,
    Plain,
}

/// Material Type
/// used later in the LOOK system and others to compose
/// description strings and to determine base functionality
#[derive(Serde, Copy, Drop, Introspect)]
enum MaterialType {
    Wood,
    Dirt,
    Stone,
    Flesh,
    Glass,
    IKEA,
    Iron,
    Shit,
    Mud,
    None,
}

/// MaterialType -> short_string or felt252
/// 
/// implements the Into trait and gives a <= 32 char i.e 32 * 8 bits  
impl MT_to_Felt252 of Into<MaterialType, felt252> {
    fn into(self: MaterialType) -> felt252 {
        match self {
            MaterialType::Wood => 'wood',
            MaterialType::Dirt => 'dirt',
            MaterialType::Stone => 'stone',
            MaterialType::Flesh => 'flesh',
            MaterialType::Glass => 'glass ',
            MaterialType::IKEA => 'IKEA',
            MaterialType::Iron => 'iron',
            MaterialType::Shit => 'shit',
            MaterialType::Mud => 'mud',
            _ => 'none',
        }
    }
}

/// Direction Type
/// used by the direction syetm to determine movement
/// and ofc the direction of things in the world
#[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
enum DirectionType {
    North,
    East,
    South,
    West,
    Up,
    Down,
    Left,
    Right,
    None,
}


/// Action Type
/// used later in the VRB/ACTION handling system and others to compose
/// behaviour handling operations
#[derive(Serde, Drop, Copy, Destruct, Introspect, Debug, PartialEq)]
enum ActionType {
    Move,
    Look,
    Kick,
    Hit,
    Drink,
    Fight,
    Sleep,
    Smash,
    Pray,
    Open,
    None,
}

/// Text Definition Types
#[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
enum TxtDefType {
    DirObj,
    Dir,
    Place,
    Object,
    Action,
    None,
}

/// Object Types
#[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
enum ObjectType {
    Ball,
    Window,
    Door,
    Hit,
    Troll,
    Path,
    None,
}
