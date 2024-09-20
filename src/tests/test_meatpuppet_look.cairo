#[cfg(test)]
mod tests {
     use core::clone::Clone;
    use core::array::ArrayTrait;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{deploy_contract, spawn_test_world};

    use the_oruggin_trail::lib::hash_utils::hashutils as h_util;

    use the_oruggin_trail::systems::{
        meatpuppet::{meatpuppet, IListenerDispatcher, IListenerDispatcherTrait},
        spawner::{spawner, ISpawnerDispatcher, ISpawnerDispatcherTrait}
    };

    use the_oruggin_trail::{
        constants::zrk_constants::{roomid as rm, roomid_to_str as rts},
        models::{
            txtdef::{Txtdef, txtdef}, room::{Room, room},
            action::{Action, action},
            object::{Object, object},
            output::{Output, output},
            player::{Player, player},
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType, RoomType}
        },
        lib::hash_utils::hashutils as p_hash
    };

    use the_oruggin_trail::tests::test_rig::{
        test_rig,
        test_rig::{Systems, ZERO, OWNER, OTHER}
    };
    

    /// Handling for Look
    /// 
    /// We want to see that the correct string hand been generated for
    /// cmds of the LOOK type. i.e. `LOOK AROUND` | `LOOK` wil generate a
    /// description string composed from the Object graph
    #[test]
    #[available_gas(200000000)]
    fn test_look_around() {
        // let caller = starknet::contract_address_const::<0x0>();
        let sys: Systems = test_rig::setup_world();
        let pid: felt252 = 23;

        let rm_name: ByteArray = rts(rm::PASS);
        let rm_id = h_util::str_hash(@rm_name);

        let mp: IListenerDispatcher = sys.listener;

        let input: Array<ByteArray> = array!["look", "around", "the", "room"];
        mp.listen(input, pid);

        let expected: ByteArray = "the pass winds through the mountains, the path is treacherous\ntoilet papered trees cover the steep \nvalley sides below you.\nOn closer inspection the TP might \nbe the remains of a cricket team\nor perhaps a lost and very dead KKK picnic group.\nIt's brass monkeys.\nthere is a dirt path to the west\n";
        let output = get!(sys.world, 23, (Output));
        let actual = output.text_o_vision;
        assert_eq!(expected, actual, "Expected {:?} got {:?}", expected, actual);
    }
    /// Generate the short description of the room
    /// 
    /// this is composed of the room type and biome and name/shortTxt
    /// it gives a general description text without parsing the objects etc into the text
    #[test]
    #[available_gas(200000000)]
    fn test_player_spawns_in_pass() {
        let sys: Systems = test_rig::setup_world();
        let mp: IListenerDispatcher = sys.listener;
        let pid: felt252 = 23;
        let input: Array<ByteArray> = array!["look", "around"];
        mp.listen(input, pid);
        let expected: ByteArray = "walking eagle pass\nYou are standing on a pass in the mountains";
        let output = get!(sys.world, 23, (Output));
        let actual = output.text_o_vision;
        assert_eq!(expected, actual, "Expected {:?} got {:?}", expected, actual);
    }

    ///test that meatpuppet can call spawner
    #[test]
    fn test_mp_spawns_player() {
        let sys: Systems = test_rig::setup_world();
        let mp: IListenerDispatcher = sys.listener;
        let pid: felt252 = 23;
        let input: Array<ByteArray> = array!["look", "around"];
        mp.listen(input, pid);
        let player = get!(sys.world, pid, (Player));
        let rm_name: ByteArray = "walking eagle pass";
        let expected_room_id = p_hash::str_hash(@rm_name);
        assert_eq!(expected_room_id, player.location,  "Expected {:?} got {:?}", expected_room_id, player.location);
        let room = get!(sys.world, expected_room_id, (Room));
        assert_eq!(room.roomType, RoomType::Pass);
    }
    
}
