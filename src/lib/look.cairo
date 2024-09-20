//! Handle LOOK type actions
pub mod lookat {
    use the_oruggin_trail::constants::zrk_constants::{ErrCode as ec};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::models::{
        player::Player, 
        room::Room, 
        zrk_enums::{
            RoomType, room_type_to_str, 
            BiomeType, biome_type_to_str, 
            MaterialType, material_type_to_str, 
            ObjectType, object_type_to_str, 
            DirectionType, direction_type_to_str
        }, 
        txtdef::Txtdef, 
        object::Object
    };

    /// look at stuff
    /// 
    /// should take the garble and then decide to exmine a thing or look around.
    /// the general case is assumed to be for a room
    pub fn stuff(ref world: IWorldDispatcher, thing: Garble, pid: felt252) -> ByteArray {
        //get the player object
        // we are always player 23 right now
        let player: Player = get!(world, pid, (Player) );
        let location: felt252 = player.location;
        let mut output: ByteArray = describe_room(world, location);
        output
    }

    fn collate_objects(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    fn collate_exits(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let room: Room = get!(world, location, (Room));
        let mut exits: Array<felt252> = room.dirObjIds.clone();
        let mut idx: u32 = 0;
        let mut out: ByteArray = "";
        let base:ByteArray = "there is a";
        let dir_connective:ByteArray = "to the";
        while idx < exits.len() {
            let rm_id: felt252 = exits.at(idx).clone();
            let exit: Object = get!(world, rm_id, (Object));
            let mut desc: ByteArray = 
                format!("{} {} {} {} {}\n", 
                base.clone(),
                material_type_to_str(exit.matType),
                object_type_to_str(exit.objType),
                dir_connective.clone(),
                direction_type_to_str(exit.dirType)
            );
            out.append(@desc);
            idx += 1;
        };
        out
    }

    fn describe_object(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    /// describe the room, simple version
    ///
    /// ignores the objects in the place and generates
    /// a text descirption from the properties and shortTxt
    /// 
    /// format as follows:
    /// 
    /// "walking eagle pass" : name - shortTxt
    /// "You are standing on/in a pass in/on the prarie" : baseTxt + conn + roomType + conn + biomeType
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

    /// describe the room, bigger version
    ///
    /// loops through the objects in the place and generates
    /// a text descirption from the properties of the objects
    /// 
    /// format as follows:
    /// "the valley sides ...": txtDefId
    /// "you can see a path to the west ..." : exits - dirObjects
    /// "there is a manky otter pelt on the floor": objects
    fn describe_room(world: IWorldDispatcher, location: felt252) -> ByteArray {
        let room: Room = get!(world, location, (Room));
        let txt: ByteArray = get!(world, room.txtDefId, (Txtdef)).text;
        let connective_txt: ByteArray = "the";
        let place_type: ByteArray = room_type_to_str(room.roomType);
        let exit_txt: ByteArray = collate_exits(world, location);
        format!(
            "{} {} {}\n{}", 
            connective_txt.clone(), 
            place_type, 
            txt,
            exit_txt
        )
    }

}
