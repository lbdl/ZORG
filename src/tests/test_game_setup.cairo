#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    // import test utils
    use the_oruggin_trail::{
        systems::{
            spawner::{spawner, ISetupDispatcher, ISetupDispatcherTrait}
            },
        models::{
            zrk_enums::{MaterialType, ActionType}
        },
        meat_space::meat_world::{TxtDefStore}
    };


    #[test]
    #[available_gas(30000000)]
    fn test_spawn() {
        let caller = starknet::contract_address_const::<0x0>();

        let mut models = array![meat_world::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', spawner::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = ISetupDispatcher { contract_address };
        sut.spawn();
        
        let model = get!(world, 23, TxtDefStore);
        let expected = "foo";
        let actual = model.value;
        assert_eq!(actual, expected, "got {:?}, expected {:?}");
    }

}