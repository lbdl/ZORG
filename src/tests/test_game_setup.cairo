#[cfg(test)]
mod tests {
    use core::clone::Clone;
    use core::array::ArrayTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};

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

    // #[test]
    // #[available_gas(30000000)]
    // fn test_spawn_counter() {
    //     let mut models = array![txtdef::TEST_CLASS_HASH];
    //     let world = spawn_test_world(models);

    //     // deploy systems contract
    //     let contract_address = world
    //         .deploy_contract(
    //             'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
    //         );
    //     let sut = ISpawnerDispatcher { contract_address };
    //     sut.setup();

    //     let counter = get!(world, 666, (Spawncount));
    //     assert_eq!(counter.a_c, 1, "got {:?}, expected {:?}", counter.a_c, 1);
    //     assert_eq!(counter.d_c, 1, "got {:?}, expected {:?}", counter.d_c, 1);
    //     assert_eq!(counter.o_c, 1, "got {:?}, expected {:?}", counter.o_c, 1);
    // }

    #[test]
    #[available_gas(30000000)]
    fn test_spawn_text_defintion() {
        let mut models = array![txtdef::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let sut = ISpawnerDispatcher { contract_address };
        sut.setup();
    // TODO fix this to take a phash from the mock model
    // let model = get!(world, rm::West, (Txtdef));
    // let expected: ByteArray = "a high mountain west that winds along...";
    // let actual = model.text;
    // assert_eq!(actual, expected, "got {:?}, expected {:?}", actual, expected);
    }

    #[test]
    #[available_gas(30000000)]
    fn test_spawn_room() {
        let mut models = array![txtdef::TEST_CLASS_HASH, action::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let sut = ISpawnerDispatcher { contract_address };
        sut.setup();
    // TODO fix this to take a phash from the mock model
    // let model = get!(world, rm::west, (Txtdef));
    // let expected: ByteArray = "a high mountain west that winds along...";
    // let actual = model.text;
    // assert_eq!(actual, expected, "got {:?}, expected {:?}", actual, expected);
    }

    #[test]
    #[available_gas(30000000)]
    fn test_spawn_room_WEST_properties() {
        let mut models = array![// txtdef::TEST_CLASS_HASH,
        // action::TEST_CLASS_HASH,
        object::TEST_CLASS_HASH// room::TEST_CLASS_HASH
        ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let sut = ISpawnerDispatcher { contract_address };

        sut.setup();

        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = obj_phash();

        let west: Object = get!(world, pass_id, (Object));

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
            west.matType,
            MaterialType::Dirt
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
    #[available_gas(30000000)]
    fn test_spawn_room_object_properties() {
        let mut models = array![
            txtdef::TEST_CLASS_HASH,
            action::TEST_CLASS_HASH,
            object::TEST_CLASS_HASH,
            room::TEST_CLASS_HASH
        ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let sut = ISpawnerDispatcher { contract_address };

        sut.setup();

        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(world, pass_id, (Room));

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
        let txt = get!(world, txtid, (Txtdef));
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
    #[available_gas(30000000)]
    fn test_spawn_room_object_exit_properties() {
        let mut models = array![
            txtdef::TEST_CLASS_HASH,
            action::TEST_CLASS_HASH,
            object::TEST_CLASS_HASH,
            room::TEST_CLASS_HASH
        ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract('salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span());
        let sut = ISpawnerDispatcher { contract_address };

        sut.setup();

        let room_name: ByteArray = "walking eagle pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(world, pass_id, (Room));

        //! exits should have one 
        let exits: Array<felt252> = pass.dirObjIds.clone();
        assert_ne!(exits.len(), 0, "got {:?}, expected {:?}", exits.len(), 0);
        //! exit id's should match
        let exitid = exits.at(0).clone();
        let actual_exit: Object = get!(world, exitid, (Object));
        let actual_id = actual_exit.objectId.clone();
        let expected_id = exitid.clone();
        assert_eq!(expected_id, actual_id, "got {:?}, expected {:?}", exitid, actual_id);
    }
}
