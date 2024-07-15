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
            actions::{actions, IActionsDispatcher, IActionsDispatcherTrait},
            outputter::{outputter, IOutputterDispatcher, IOutputterDispatcherTrait},
            },
        models::{
            zrk_enums::{MaterialType, ActionType},
            output::{Output, output}
        }
    };
}