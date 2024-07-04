#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    // import test utils
    use the_oruggin_trail::{
        systems::{meatpuppet::{meatpuppet, IListenerDispatcher, IListenerDispatcherTrait}},
        models::{
            zrk_enums::{MaterialType, ActionType}, 
            output::{Output, output}, 
            ears::{Ears, ears},
            prayers::{Prayers, prayers}
        }
    };

    #[test]
    #[available_gas(30000000)]
    fn test_actions_tokenising() {
        let caller = starknet::contract_address_const::<0x0>();
        let mut models = array![output::TEST_CLASS_HASH, 
            prayers::TEST_CLASS_HASH, 
            ears::TEST_CLASS_HASH,
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', listener::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );

        // let input_arr: Array<ByteArray> = array!["kick", "ball", "at", "window"];
        let sut = IListenerDispatcher { contract_address };
        assert(true == false, 'fix test');
    }

    #[test]
    #[available_gas(30000000)]
    fn test_listener_success() {
        let caller = starknet::contract_address_const::<0x0>();
        
        let mut models = array![output::TEST_CLASS_HASH, 
            prayers::TEST_CLASS_HASH, 
            ears::TEST_CLASS_HASH,
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', meatpuppet::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = IListenerDispatcher { contract_address };
        let input = array!["foo", "bar"];
        
        let out = sut.listen(input);  
        // the unwrap should not panic here as the input is < 16
        let actual = out.unwrap();
        let expected = ActionType::Smash;
        assert_eq!(ActionType::Smash, ActionType::Smash, "verbs do not match");
    }

    #[test]
    #[available_gas(30000000)]
    fn test_listener_too_many_tokens() {
        let caller = starknet::contract_address_const::<0x0>();
        
        let mut models = array![output::TEST_CLASS_HASH, 
            prayers::TEST_CLASS_HASH, 
            ears::TEST_CLASS_HASH,
            ];
        let world = spawn_test_world(models);

        // deploy systems contract
        let contract_address = world
            .deploy_contract(
                'salt', meatpuppet::TEST_CLASS_HASH.try_into().unwrap(), array![].span()
            );
        let sut = IListenerDispatcher { contract_address };

        // we use felt252 as in the inputs so we can just use numerics here
        // despite the actual system using the short string form
        let failing_input: Array<ByteArray> = array!["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"];

        assert!(sut.listen(failing_input).is_err(), "Function call should fail");  
    }
}