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
    #[available_gas(40000000)]
    fn test_spawn_pass_WEST_properties() {
        // west
        // material is dirt
        // dir is west
        // dest is bensons plain
        // object actions should be present
        // action should be enabled
        // action should be open
        // action should be !revertable
        // action should be dBit
        // action should be affectedByActionId 0
        // action should be affectsActionId 0
        // action txt should be "the path winds west, it is open"
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();

        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = obj_phash();
        let west: Object = get!(sys.world, pass_id, (Object));

        //! assert on the WEST objects properties
        assert_eq!(
            west.objType,
            ObjectType::Path,
            "got {:?}, expected {:?}",
            west.objType,
            ObjectType::Path
        );
        assert_eq!(
            west.matType,
            MaterialType::Dirt,
            "got {:?}, expected {:?}",
            west.matType,
            MaterialType::Dirt
        );
        assert_eq!(
            west.dirType,
            DirectionType::West,
            "got {:?}, expected {:?}",
            west.dirType,
            DirectionType::West
        );

        let destination_name: ByteArray = "bensons plain";
        let dst_id: felt252 = p_hash::str_hash(@destination_name);
        assert_eq!(west.destId, dst_id, "got {:?}, expected {:?}", west.destId, rm::PLAIN);
        assert_ne!(
            west.objectActionIds.len(), 0, "got {:?}, expected {:?}", west.objectActionIds.len(), 0
        );
        //! assert the action has the expected ID
        let expected = act_phash();
        let actual: felt252 = west.objectActionIds.at(0).clone();
        assert_eq!(
            actual, expected, "got {:?}, expected {:?}", west.objectActionIds.at(0), act_phash()
        );
        // assert the action's properties 
        let expected_action: Action = get!(sys.world, actual, (Action));
        let expected_txt: ByteArray = "the path winds west, it is open";
        let actual_txt = expected_action.dBitTxt.clone();

        // action txt should be "the path winds west, it is open"e correct
        assert_eq!(actual_txt, expected_txt, "got {:?}, expected {:?}", actual_txt, expected_txt);
        // action should be enabled
        assert_eq!(expected_action.enabled, true, "got {:?}, expected {:?}", expected_action.enabled, true);
        // action should be open
        assert_eq!(expected_action.actionType, ActionType::Open, "got {:?}, expected {:?}", expected_action.actionType, ActionType::Open);
        // action should be !revertable
        assert_eq!(expected_action.revertable, false, "got {:?}, expected {:?}", expected_action.revertable, false);
        // action should be dBit
        assert_eq!(expected_action.dBit, true, "got {:?}, expected {:?}", expected_action.dBit, true);
        // action should be affectedByActionId 0
        assert_eq!(expected_action.affectedByActionId, 0, "got {:?}, expected {:?}", expected_action.affectedByActionId, 0);
        // action should be affectsActionId 0
        assert_eq!(expected_action.affectsActionId, 0, "got {:?}, expected {:?}", expected_action.affectsActionId, 0);
    }

    #[test]
    #[available_gas(50000000)]
    fn test_spawn_pass_object_properties() {
    
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();

        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(sys.world, pass_id, (Room));

        //! assert on the PASS objects properties
        //! the name/short description property
        assert_eq!(
            pass.roomType,
            RoomType::Mountains,
            "got {:?}, expected {:?}",
            pass.roomType,
            RoomType::Mountains
        );
        let expected_name: ByteArray = "walking eagle pass";
        let actual = pass.shortTxt.clone();
        assert_eq!(actual, expected_name, "got {:?}, expected {:?}", pass.shortTxt, expected_name);

        //! check the stored text values
        let txtid = pass.txtDefId;
        let txt = get!(sys.world, txtid, (Txtdef));
        let actual_desc = txt.text.clone();
        let expected_desc: ByteArray = "it winds through the mountains, the path is treacherous\n
                         toilet papered trees cover the steep \nvalley sides below you.\n
                         On closer inspection the TP might \nbe the remains of a cricket team\n
                         or perhaps a lost and very dead KKK picnic group.\n
                         It's brass monkeys.";
        assert_eq!(actual_desc, expected_desc, "got {:?}, expected {:?}", txt.text, expected_desc);
        
        let actual_owner = txt.owner;
        let expected_owner = pass_id.clone();
        // owner should be the pass id
        assert_eq!(
            actual_owner, expected_owner, "got {:?}, expected {:?}", txt.owner, expected_owner
        );

        // check the objects and players
        // objects should be empty
        let objects: Array<felt252> = pass.objectIds.clone();
        assert_eq!(objects.len(), 0, "got {:?}, expected {:?}", objects.len(), 0);

        // players should be empty
        let players: Array<felt252> = pass.players.clone();
        assert_eq!(players.len(), 0, "got {:?}, expected {:?}", players.len(), 0);
    }

    #[test]
    #[available_gas(40000000)]
    fn test_spawn_pass_object_exit_properties() {

        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();


        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(sys.world, pass_id, (Room));

        //! exits should have one 
        let exits: Array<felt252> = pass.dirObjIds.clone();
        assert_ne!(exits.len(), 0, "got {:?}, expected {:?}", exits.len(), 0);
        //! exit id's should match
        let exitid = exits.at(0).clone();
        let actual_exit: Object = get!(sys.world, exitid, (Object));
        let actual_id = actual_exit.objectId.clone();
        let expected_id = exitid.clone();
        assert_eq!(expected_id, actual_id, "got {:?}, expected {:?}", exitid, actual_id);
    }
}
