/// The main Inerface for the system
/// 
/// Exprected to take an array of str from an RPC call
/// and to then lex and extract semantic information 
/// pre passing this information on to the rest
/// of the system.
#[dojo::interface]
trait IListener {
    fn listen(cmd: Array<ByteArray>);
}

/// Impl of the listener
/// acts as a main() and takes a command
/// which is then lexed and then has semantic
/// meaning extracted into a small struct
/// which can then be passed along to the next
/// logical block/system
#[dojo::contract]
mod meatpuppet {
    use super::{IListener};
    use starknet::{ContractAddress, ClassHash, get_caller_address};
    use the_oruggin_trail::models::{output::{Output}, zrk_enums::{ActionType, ObjectType}};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};

    use the_oruggin_trail::constants::zrk_constants::ErrCode as ec;
    use the_oruggin_trail::lib::insult_meat::insulter as badmouth;

    // #[storage]
    // struct Storage {
    //     tokeniser_adr: ContractAddress,
    //     tokeniser_cls: ClassHash,
    // }

    // fn dojo_init(
    //     world: @IWorldDispatcher, tokeniser_address: ContractAddress, tokeniser_class: ClassHash,
    // ) {// TODO: add a model to store the systems we want to call
    // // then set the values from here
    // }

    #[abi(embed_v0)]
    impl ListenImpl of IListener<ContractState> {
        fn listen(world: @IWorldDispatcher, cmd: Array<ByteArray>) {
            //! we use this as an error flag to kick us into error
            //! catching routines later as we run the parses over
            //! the command string
            let mut isErr: ec =  ec::None;
            let l_cmd = @cmd;
            let l_cmd_cpy = l_cmd.clone();
            if l_cmd.len() >= 16 {
                // we have bad food make an error and pass along to 
                // the error outputter system
                isErr = ec::BadLen;
            } else {
                // grab the command stream array and extract a Garble type
                match confessor::confess(l_cmd_cpy) {
                    Result::Ok(r) => {},
                    Result::Err(r) => {
                        isErr = r;
                    }
                }
            }

            if isErr != ec::None {
                // exit routine
                let speech = badmouth::opine_on_errors(isErr, l_cmd);
                let bogus_id = 23;
                // let speech = "foopy pants";
                set!(world, Output { playerId: bogus_id, text_o_vision: speech,});
            }
        }
    }

    // fn handleGarble() -> 

}
