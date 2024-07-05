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
            tokeniser::{tokeniser}
            },
        models::{
            zrk_enums::{MaterialType, ActionType, ObjectType}
        }
    };

    #[test]
    #[available_gas(30000000)]
    fn test_actions_tokenising() {
        let bad_str: ByteArray = "foo";
        let good_str: ByteArray = "move";
        let tok_good = tokeniser::str_to_AT(good_str);
        let tok_none = tokeniser::str_to_AT(bad_str);
        assert(tok_good == ActionType::Move, 'expected MOVE');
        assert(tok_none == ActionType::None, 'expected NONE');
    }
    
    #[test]
    #[available_gas(30000000)]
    fn test_objects_tokenising() {
        let bad_str: ByteArray = "foo";
        let good_str: ByteArray = "ball";
        let tok_good = tokeniser::str_to_OT(good_str);
        let tok_none = tokeniser::str_to_OT(bad_str);
        assert(tok_good == ObjectType::Ball, 'expected BALL');
        assert(tok_none == ObjectType::None, 'expected NONE');
    }
}