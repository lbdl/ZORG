#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    // import test utils
    use the_oruggin_trail::{
        systems::{listener::{listener, IListenerDispatcher, IListenerDispatcherTrait}},
        models::{
            zrk_enums::{MaterialType, ActionType}, 
            output::{Output, output}, 
            ears::{Ears, ears},
            prayers::{Prayers, prayers}
        }
    };

    #[test]
    #[available_gas(30000000)]
    fn test_listener_success() {
        let caller = starknet::contract_address_const::<0x0>();
        
        let mut models = array![output::TEST_CLASS_HASH, prayers::TEST_CLASS_HASH, ears::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', listener::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let listener_system = IListenerDispatcher { contract_address };
        let input = array!['foo', 'bar'];
    }
}
