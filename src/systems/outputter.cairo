// use the_oruggin_trail::models::output::Output;

#[dojo::interface]
trait IOutputter {
    fn spawn(ref world: IWorldDispatcher);
    fn updateOutput(ref world: IWorldDispatcher, txt: ByteArray);
}

#[dojo::contract]
mod outputter {
    use super::{IOutputter};
    use starknet::{ContractAddress, get_caller_address};
    use the_oruggin_trail::models::output::{Output, OutputStore} ;

    #[abi(embed_v0)]
    impl OutputterImpl of IOutputter<ContractState> {
        fn spawn(ref world: IWorldDispatcher) {

        }

        fn updateOutput(ref world: IWorldDispatcher, txt: ByteArray) {
            //! note the hardcoded 23 as the playerId we are just keeping
            //! for the now but it should go away and be replaced with a 
            //! "real" identifier. Not sure what that looks like right now 
            
            // let out = Output{playerId: 23, text_o_vision: txt};
            // out.set!(world);

            set!(
                world,
                (
                    Output{playerId: 23, text_o_vision: txt}
                )
            ) 
        }
    }
}