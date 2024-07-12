use the_oruggin_trail::models::output::Output;

#[dojo::interface]
trait IOutputter {
    fn spawn();
    fn updateOutput(txt: ByteArray);
}

#[dojo::contract]
mod outputter {
    use super::{IOutputter};
    use starknet::{ContractAddress, get_caller_address};
    use the_oruggin_trail::models::{output::{Output}};

    #[abi(embed_v0)]
    impl OutputterImpl of IOutputter<ContractState> {
        fn spawn(world: @IWorldDispatcher) {

        }

        fn updateOutput(world: @IWorldDispatcher, txt: ByteArray) {
            // let in = txt.clone();
            let out = array![txt];  
            set!(
                world,
                (
                    Output{playerId: 23, text_o_vision: out}
                )
            ) 
        }
    }


}