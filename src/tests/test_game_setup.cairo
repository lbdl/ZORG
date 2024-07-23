#[cfg(test)]
mod tests {
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
            txtdef::{Txtdef, txtdef}, room::{Room, room, room_mock_hash as rm_phash},
            action::{Action, action, action_mock_hash as act_phash}, 
            object::{Object, object, obj_mock_hash as obj_phash},
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType}},
        lib::hash_utils as pi_hash

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
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
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
        let mut models = array![
            txtdef::TEST_CLASS_HASH,
            action::TEST_CLASS_HASH
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
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
        let mut models = array![
            // txtdef::TEST_CLASS_HASH,
            // action::TEST_CLASS_HASH,
            object::TEST_CLASS_HASH
            // room::TEST_CLASS_HASH
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISpawnerDispatcher { contract_address };

        sut.setup();
        
        let pass_id: felt252 = obj_phash();
        
        let west: Object = get!(world, pass_id, (Object));
        
        //! assert on the WEST objects properties
        assert_eq!(west.objType, ObjectType::Path, "got {:?}, expected {:?}", west.objType, ObjectType::Path);
        assert_eq!(west.matType, MaterialType::Dirt, "got {:?}, expected {:?}", west.matType, MaterialType::Dirt);
        assert_eq!(west.dirType, DirectionType::West, "got {:?}, expected {:?}", west.matType, MaterialType::Dirt);
        assert_eq!(west.destId, rm::PLAIN, "got {:?}, expected {:?}", west.destId, rm::PLAIN);
        assert_ne!(west.objectActionIds.len(), 0, "got {:?}, expected {:?}", west.objectActionIds.len(), 0);
        //! assert the action has the expected ID
        let expected = act_phash();
        let actual: felt252 = west.objectActionIds.at(0).clone();
        assert_eq!(actual, expected , "got {:?}, expected {:?}", west.objectActionIds.at(0), act_phash());
    }

#[test]
    #[available_gas(30000000)]
    fn test_spawn_room_object_graph_properties() {
        let mut models = array![
            txtdef::TEST_CLASS_HASH,
            action::TEST_CLASS_HASH,
            object::TEST_CLASS_HASH,
            room::TEST_CLASS_HASH
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISpawnerDispatcher { contract_address };

        sut.setup();
        
        let pass_id: felt252 = obj_phash();
        
        let west: Object = get!(world, pass_id, (Object));
        
        //! assert on the WEST objects properties
        assert_eq!(west.objType, ObjectType::Path, "got {:?}, expected {:?}", west.objType, ObjectType::Path);
        assert_eq!(west.matType, MaterialType::Dirt, "got {:?}, expected {:?}", west.matType, MaterialType::Dirt);
        assert_eq!(west.dirType, DirectionType::West, "got {:?}, expected {:?}", west.matType, MaterialType::Dirt);
        assert_eq!(west.destId, rm::PLAIN, "got {:?}, expected {:?}", west.destId, rm::PLAIN);
        assert_ne!(west.objectActionIds.len(), 0, "got {:?}, expected {:?}", west.objectActionIds.len(), 0);

        //! assert on the linked text
        let txt_id = west.txtDefId;
        let txt_def: Txtdef = get!(world, txt_id, (Txtdef));
        let expected: ByteArray = "path";
        let actual = txt_def.text.clone();
        assert_eq!(actual, expected, "got {:?}, expected {:?}", txt_def.text, expected);

        //! assert on the WEST actions
        let acts = west.objectActionIds;
        let id_a = *acts.at(0);
        let vrb: Action = get!(world, id_a, (Action));
        assert_eq!(vrb.actionType, ActionType::Open, "got {:?}, expected {:?}", vrb.actionType, ActionType::Open);
        // assert on the WEST text
        let expected: ByteArray = "the path winds west, it is open";
        let actual = vrb.dBitTxt.clone();
        assert_eq!(actual, expected, "got {:?}, expected {:?}", vrb.dBitTxt, expected);
        // flags
        assert_eq!(vrb.enabled, true, "got {:?}, expected {:?}", vrb.enabled, true);
        assert_eq!(vrb.revertable, false, "got {:?}, expected {:?}", vrb.revertable, false);
        assert_eq!(vrb.dBit, true, "got {:?}, expected {:?}", vrb.dBit, true);
        // relations
        assert_eq!(vrb.affectsActionId, 0, "got {:?}, expected {:?}", vrb.affectsActionId, 0);
        assert_eq!(vrb.affectedByActionId, 0, "got {:?}, expected {:?}", vrb.affectedByActionId, 0);
    }


}