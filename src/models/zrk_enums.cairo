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

impl BT_to_Felt252 of Into<BiomeType, felt252> {
    fn into(self: BiomeType) -> felt252 {
        match self {
            BiomeType::Forest => 'forest',
            BiomeType::Tundra => 'tundra',
            BiomeType::Arctic => 'arctic',
            BiomeType::Desert => 'desert',
            BiomeType::Temporate => 'temporate',
            BiomeType::Faery => 'faery',
            BiomeType::Demon => 'demon',
            BiomeType::None => 'none',
        }
    }
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

impl RT_to_Felt252 of Into<RoomType, felt252> {
    fn into(self: RoomType) -> felt252 {
        match self {
            RoomType::WoodCabin => 'wood cabin',
            RoomType::Store => 'store',
            RoomType::Cavern => 'cavern',
            RoomType::StoneCabin => 'stone cabin',
            RoomType::Fort => 'fort',
            RoomType::Plain => 'plain',
            RoomType::Room => 'room',
            RoomType::None => 'none',
        }
    }
}

/// Material Type
/// used later in the LOOK system and others to compose
/// description strings and to determine base functionality
#[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
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

impl DT_to_Felt252 of Into<DirectionType, felt252> {
    fn into(self: DirectionType) -> felt252 {
        match self {
            DirectionType::North => 'north',
            DirectionType::East => 'east',
            DirectionType::South => 'south',
            DirectionType::West => 'west',
            DirectionType::Up => 'up',
            DirectionType::Down => 'down',
            DirectionType::Left => 'left',
            DirectionType::Right => 'right',
            DirectionType::None => 'none',
        }
    }
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

impl AT_to_Felt252 of Into<ActionType, felt252> {
    fn into(self: ActionType) -> felt252 {
        match self {
            ActionType::Move => 'move',
            ActionType::Look => 'look',
            ActionType::Kick => 'kick',
            ActionType::Hit => 'hit',
            ActionType::Drink => 'drink',
            ActionType::Fight => 'fight',
            ActionType::Sleep => 'sleep',
            ActionType::Smash => 'smash',
            ActionType::Pray => 'pray',
            ActionType::Open => 'open',
            ActionType::None => 'none',
        }
    }
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

impl TDT_to_Felt252 of Into<TxtDefType, felt252> {
    fn into(self: TxtDefType) -> felt252 {
        match self {
            TxtDefType::DirObj => 'dirobj',
            TxtDefType::Dir => 'dir',
            TxtDefType::Place => 'place',
            TxtDefType::Object => 'object',
            TxtDefType::Action => 'action',
            TxtDefType::None => 'none',
        }
    }
}
/// Object Types
#[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
enum ObjectType {
    Ball,
    Window,
    Door,
    Stairs,
    Place,
    Troll,
    Path,
    None,
}

impl OT_to_Felt252 of Into<ObjectType, felt252> {
    fn into(self: ObjectType) -> felt252 {
        match self {
            ObjectType::Ball => 'ball',
            ObjectType::Window => 'window',
            ObjectType::Door => 'door',
            ObjectType::Stairs => 'stairs',
            ObjectType::Place => 'place',
            ObjectType::Troll => 'troll',
            ObjectType::Path => 'path',
            ObjectType::None => 'none',
        }
    }
}