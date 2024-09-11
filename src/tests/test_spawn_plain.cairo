#[cfg(test)]
mod tests {
    use core::clone::Clone;
    use core::array::ArrayTrait;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{deploy_contract, spawn_test_world};

    use the_oruggin_trail::{
        systems::{spawner::{spawner, ISpawnerDispatcher, ISpawnerDispatcherTrait}},
        constants::zrk_constants::roomid as rm,
        models::{
            txtdef::{Txtdef, txtdef}, room::{Room, room},
            action::{Action, action, action_mock_hash as act_phash},
            object::{Object, object, obj_mock_hash as obj_phash},
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType, RoomType}
        },
        lib::hash_utils::hashutils as p_hash
    };

    use the_oruggin_trail::tests::test_rig::{
        test_rig,
        test_rig::{Systems, ZERO, OWNER, OTHER}
    };


    #[test]
    #[available_gas(50000000)]
    fn test_spawn_plain_room_properties() {
        // room should contain 0 objects
        // room should contain 0 players
        // room should have 1 exit
        // room should have 1 textdef
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();

        let room_name: ByteArray = "bensons plain";
        let plain_id: felt252 = p_hash::str_hash(@room_name);

        let plain: Room = get!(sys.world, plain_id, (Room));

        // assert on the PASS objects properties
        // the name/short description property
        assert_eq!(
            plain.roomType,
            RoomType::Plain,
            "got {:?}, expected {:?}",
            plain.roomType,
            RoomType::Plain
        );

        let expected_name: ByteArray = "bensons plain";
        let actual = plain.shortTxt.clone();
        assert_eq!(actual, expected_name, "got {:?}, expected {:?}", plain.shortTxt, expected_name);

        //! check the stored text values
        let txtid = plain.txtDefId;
        let txt = get!(sys.world, txtid, (Txtdef));
        let actual_desc = txt.text.clone();
        let expected_desc: ByteArray = 
                "it winds through the mountains, the path is treacherous\n
                toilet papered trees cover the steep \n
                valley sides below you.\n
                On closer inspection the TP might \n
                be the remains of a cricket team\n
                or perhaps a lost and very dead KKK picnic group.\n
                It's brass monkeys.";

        // assert description should be as expected
        assert_eq!(actual_desc, expected_desc, "got {:?}, expected {:?}", txt.text, expected_desc);
        
        let actual_owner = txt.owner;
        let expected_owner = plain_id.clone();

        // owner should be the pass id
        assert_eq!(
            actual_owner, expected_owner, "got {:?}, expected {:?}", txt.owner, expected_owner
        );

        // check the objects and players
        // object ids should contain 1 item
        let objects: Array<felt252> = plain.objectIds.clone();
        assert_eq!(objects.len(), 1, "got {:?}, expected {:?}", objects.len(), 1);

        // player ids should be empty
        let players: Array<felt252> = plain.players.clone();
        assert_eq!(players.len(), 1, "got {:?}, expected {:?}", players.len(), 1);

        // check the rooms exits
        // there should be 2 exits
        let exits: Array<felt252> = plain.dirObjIds.clone();
        assert_eq!(exits.len(), 2, "got {:?}, expected {:?}", exits.len(), 2);
    }

    #[test]
    #[available_gas(50000000)]
    fn test_spawn_pass_exit_properties () {
        // room should have:
        // 1 exit
        // exit should have:
        // 1 action
        // action should be:
        // open
        // revertable
        // dBit
        // enabled
        // affectsActionId 0
        // affectedByActionId 0
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();


        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(sys.world, pass_id, (Room));

        // room should have one exit 
        let exits: Array<felt252> = pass.dirObjIds.clone();
        assert_eq!(exits.len(), 1, "got {:?}, expected {:?}", exits.len(), 1);
        
        // exit should have:
        // 1 action
        let exit_id = exits.at(0).clone();
        let exit: Object = get!(sys.world, exit_id, (Object));
        let actions: Array<felt252> = exit.objectActionIds.clone();
        assert_eq!(actions.len(), 1, "got {:?}, expected {:?}", actions.len(), 1);

        let action_id = actions.at(0).clone();
        let action: Action = get!(sys.world, action_id, (Action));

        // action should be:
        // open
        assert_eq!(action.actionType, ActionType::Open, "got {:?}, expected {:?}", action.actionType, ActionType::Open);
        // !revertable
        assert_eq!(action.revertable, false, "got {:?}, expected {:?}", action.revertable, false);
        // dBit
        assert_eq!(action.dBit, true, "got {:?}, expected {:?}", action.dBit, true);
        // enabled
        assert_eq!(action.enabled, true, "got {:?}, expected {:?}", action.enabled, true);
        // affectsActionId 0
        assert_eq!(action.affectsActionId, 0, "got {:?}, expected {:?}", action.affectsActionId, 0);
        // affectedByActionId 0
        assert_eq!(action.affectedByActionId, 0, "got {:?}, expected {:?}", action.affectedByActionId, 0);
    }
}
