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
        constants::zrk_constants::roomid as room,
        models::{
            txtdef::{Txtdef, txtdef},
            action::{Action, action}, 
            object::{Object, object},
            spawncount::{Spawncount, spawncount},
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType}},
        lib::hash_utils as pi_hash

    };
    
    #[test]
    #[available_gas(30000000)]
    fn test_spawn_counter() {
        let mut models = array![txtdef::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISpawnerDispatcher { contract_address };
        sut.setup();

        let counter = get!(world, 666, (Spawncount));
        assert_eq!(counter.a_c, 1, "got {:?}, expected {:?}", counter.a_c, 1);
        assert_eq!(counter.d_c, 1, "got {:?}, expected {:?}", counter.d_c, 1);
        assert_eq!(counter.o_c, 1, "got {:?}, expected {:?}", counter.o_c, 1);
    }

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
        
        let model = get!(world, room::PASS, (Txtdef));
        let expected: ByteArray = "a high mountain pass that winds along...";
        let actual = model.text;
        assert_eq!(actual, expected, "got {:?}, expected {:?}", actual, expected);
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
        let model = get!(world, room::PASS, (Txtdef));
        let expected: ByteArray = "a high mountain pass that winds along...";
        let actual = model.text;
        assert_eq!(actual, expected, "got {:?}, expected {:?}", actual, expected);
    }

#[test]
    #[available_gas(30000000)]
    fn test_spawn_room_object_graph_properties() {
        let mut models = array![
            txtdef::TEST_CLASS_HASH,
            action::TEST_CLASS_HASH,
            object::TEST_CLASS_HASH
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISpawnerDispatcher { contract_address };
        sut.setup();
        let sc  = get!(world, 666, (Spawncount));
        let pass_id = 1;
        let pass: Object = get!(world, pass_id, (Object));
        
        //! assert on the properties
        assert_eq!(pass.objType, ObjectType::Path, "got {:?}, expected {:?}", pass.objType, ObjectType::Path);
        assert_eq!(pass.matType, MaterialType::Dirt, "got {:?}, expected {:?}", pass.matType, MaterialType::Dirt);
        assert_eq!(pass.dirType, DirectionType::West, "got {:?}, expected {:?}", pass.matType, MaterialType::Dirt);
        assert_eq!(pass.destId, room::PLAIN, "got {:?}, expected {:?}", pass.destId, room::PLAIN);
        assert_ne!(pass.objectActionIds.len(), 0, "got {:?}, expected {:?}", pass.objectActionIds.len(), 0);

        //! assert on the linked text
        let txt_id = pass.txtDefId;
        let txt_def: Txtdef = get!(world, txt_id, (Txtdef));
        let expected: ByteArray = "path";
        let actual = txt_def.text.clone();
        assert_eq!(actual, expected, "got {:?}, expected {:?}", txt_def.text, expected);

        //! assert on the actions
        let acts = pass.objectActionIds;
        let id_a = *acts.at(0);
        let vrb: Action = get!(world, id_a, (Action));
        assert_eq!(vrb.actionType, ActionType::Open, "got {:?}, expected {:?}", vrb.actionType, ActionType::Open);
        let expected: ByteArray = "the path winds west, it is open";
        let actual = vrb.dBitTxt.clone();
        assert_eq!(actual, expected, "got {:?}, expected {:?}", vrb.dBitTxt, expected);
        assert_eq!(vrb.enabled, true, "got {:?}, expected {:?}", vrb.enabled, true);
        assert_eq!(vrb.revertable, false, "got {:?}, expected {:?}", vrb.revertable, false);
        assert_eq!(vrb.dBit, true, "got {:?}, expected {:?}", vrb.dBit, true);
        assert_eq!(vrb.affectsActionId, 0, "got {:?}, expected {:?}", vrb.affectsActionId, 0);
        assert_eq!(vrb.affectedByActionId, 0, "got {:?}, expected {:?}", vrb.affectedByActionId, 0);
    }

}