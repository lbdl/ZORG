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
        models::{player::{Player, player}, txtdef::{Txtdef, txtdef}, zrk_enums::{MaterialType, ActionType}}
    };


    #[test]
    #[available_gas(30000000)]
    fn test_spawn() {
        //let caller = starknet::contract_address_const::<0x0>();

        let mut models = array![player::TEST_CLASS_HASH, txtdef::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISpawnerDispatcher { contract_address };
        // sut.setup();
        
        // let model = get!(world, 23, (TxtDef));
        let expected: ByteArray = "foo";
        // let actual = model.value;
        // assert_eq!(actual, expected, "got {:?}, expected {:?}", actual, expected);
    }

}