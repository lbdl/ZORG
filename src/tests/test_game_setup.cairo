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
    fn test_spawn_room_WEST_properties() {
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
    }

    #[test]
    #[available_gas(50000000)]
    fn test_spawn_room_object_properties() {
    
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
        let expected_desc: ByteArray = "a high mountain pass that winds along...";
        assert_eq!(actual_desc, expected_desc, "got {:?}, expected {:?}", txt.text, expected_desc);
        let actual_owner = txt.owner;
        let expected_owner = pass_id.clone();
        assert_eq!(
            actual_owner, expected_owner, "got {:?}, expected {:?}", txt.owner, expected_owner
        );

        //! check the objects and players
        //! objects should be empty as should players
        let objects: Array<felt252> = pass.objectIds.clone();
        assert_eq!(objects.len(), 0, "got {:?}, expected {:?}", objects.len(), 0);
        let players: Array<felt252> = pass.players.clone();
        assert_eq!(players.len(), 0, "got {:?}, expected {:?}", players.len(), 0);
    }

    #[test]
    #[available_gas(40000000)]
    fn test_spawn_room_object_exit_properties() {

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
