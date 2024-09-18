//! Handle LOOK type actions
pub mod lookat {
    use the_oruggin_trail::constants::zrk_constants::{ErrCode as ec};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::models::{player::Player, room::Room, zrk_enums::{RoomType, room_type_to_str, BiomeType, biome_type_to_str}};

    /// look at stuff
    /// 
    /// should take the garble and then decide to exmine a thing or look around.
    /// the general case is assumed to be for a room
    pub fn stuff(ref world: IWorldDispatcher, thing: Garble, pid: felt252) -> ByteArray {
        //get the player object
        // we are always player 23 right now
        let player: Player = get!(world, pid, (Player) );
        let location: felt252 = player.location;
        let mut output: ByteArray = describe_room_short(world, location);
        output
    }

    fn collate_objects(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    fn collate_exits(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    fn describe_object(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    /// describe the room
    ///
    /// loops through the objects in the place and generates
    /// a text descirption from the linked text descriptions
    /// format as follows:
    /// 
    /// "walking eagle pass" : name - shortTxt
    /// "You are standing on/in a pass in/on the prarie" : baseTxt + conn + roomType + conn + biomeType
    /// "the valley sides ...": txtDefId
    /// "you can see a path to the west ..." : exits - dirObjects
    /// "there is a manky otter pelt on the floor": objects
    pub fn describe_room_short(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let room: Room = get!(world, location, (Room));
        let mut base_txt: ByteArray = "You are standing";
        let mut connective_txt_type: ByteArray = "";
        let mut connective_txt_biome: ByteArray = "";
        if room.roomType == RoomType::Plain || room.roomType == RoomType::Pass {
            connective_txt_type = "on a";
        } else {
            connective_txt_type = "in a";
        }

        if room.biomeType == BiomeType::Prarie || room.biomeType == BiomeType::Tundra {
            connective_txt_biome = "on the";
        } else {
            connective_txt_biome = "in the";
        }

        format!(
            "{}\n{} {} {} {} {}", 
            room.shortTxt.clone(), 
            base_txt.clone(), 
            connective_txt_type, 
            room_type_to_str(room.roomType),
            connective_txt_biome,
            biome_type_to_str(room.biomeType)
        )
    }
}
