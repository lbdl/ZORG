use the_oruggin_trail::models::ears;

#[dojo::interface]
trait IListening {
    fn listen(command: Array<felt252>) -> Result<>;
}


#[dojo::contract]
mod listening {
    use super::{IListening};
    use starknet::{ContractAddress, get_caller_address};
    use the_oruggin_trail::models::{ears::{Ears}, output::{Output}};

    #[abi(embed_v0)]
    impl ListenImpl of IListening<ContractState> {
        fn listen(world: @IWorldDispatcher, command: Array<felt252>) {
            if command.len() >= 16 {

            }
        }
    }

}