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
        constants::zrk_constants::roomid as rm,
        models::{
            txtdef::{Txtdef, txtdef}, room::{Room, room},
            action::{Action, action},
            object::{Object, object},
            output::{Output, output},
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
    fn test_listener_LOOK() {
        // let caller = starknet::contract_address_const::<0x0>();
        let sys: Systems = test_rig::setup_world();
        let spawn: ISpawnerDispatcher = sys.spawner;
        let pid: felt252 = 23;
        spawn.setup();

        let rm_name: ByteArray = "walking eagle pass";
        let rm_id = h_util::str_hash(@rm_name);
        spawn.spawn_player(pid, rm_id);

        let mp: IListenerDispatcher = sys.listener;

        let input: Array<ByteArray> = array!["look", "around"];
        mp.listen(input, pid);
        let expected: ByteArray = "You see Elvis... \nhe speaks... \napparantly garbage";
        let output = get!(sys.world, 23, (Output));
        let actual = output.text_o_vision;
        assert_eq!(expected, actual, "Expected {:?} got {:?}", expected, actual);
    }
    
}
