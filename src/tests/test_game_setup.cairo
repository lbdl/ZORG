#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    // import test utils

    use the_oruggin_trail::{
        systems::{spawner::{spawner, ISpawnerDispatcher, ISpawnerDispatcherTrait}},
        constants::zrk_constants::roomid as room,
        models::{
            txtdef::{Txtdef, txtdef},
            action::{Action, action}, 
            spawncount::{Spawncount, spawncount},
            zrk_enums::{MaterialType, ActionType}}
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
        assert_eq!(counter.a_c, 0, "got {:?}, expected {:?}", 0, 0);
        assert_eq!(counter.d_c, 0, "got {:?}, expected {:?}", 0, 0);
        assert_eq!(counter.o_c, 0, "got {:?}, expected {:?}", 0, 0);

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
    fn test_spawn_room_w_doors() {
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
        assert_eq!(true, false, "IMPL INCOMPLETE-got {:?}, expected {:?}", true, false);
    }

}