pub mod pullstrings {
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

    pub fn on(world: IWorldDispatcher, pid: felt252, msg: Garble) -> ByteArray {
        let pl: Player = get!(world, pid, (Player));
        let rm: Room = get!(world, pl.location.clone(), (Room));
        let obj_tree: Array<felt252> = rm.objectIds.clone();
        let exit_tree: Array<felt252> = rm.dirObjIds.clone();
        let mut out: ByteArray = "shoggoth has got you";
        out
    }

}