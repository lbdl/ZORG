//! Handle LOOK type actions
pub mod look {
    use the_oruggin_trail::constants::zrk_constants::{ErrCode as ec};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::models::{player::Player};

    pub fn at(ref world: IWorldDispatcher, thing: Garble, pid: felt252) -> ByteArray {
        //get the player object
        // we are always player 23 right now
        let player: Player = get!(world, pid, (Player) );

        let location: felt252 = player.location;
        let mut output: ByteArray = describe_room(@world, location);
        output
    }

    fn collate_objects(world: @IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    fn collate_exits(world: @IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }

    fn describe_object(world: @IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \n, he speaks... \n apparantly garbage";
        output
    }
    /// describe the room
    /// this chains all the sub functions together
    fn describe_room(world: @IWorldDispatcher, location: felt252) -> ByteArray {
        let mut output: ByteArray = "You see Elvis... \nhe speaks... \napparantly garbage";
        output
    }

}
