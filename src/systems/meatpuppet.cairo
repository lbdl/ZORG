// /*
//  * Created on Thu Sep 05 2024
//  *
//  * Copyright (c) 2024 Archetypal Tech
//  * MeaCulpa (mc) 2024 lbdl | itrainspiders
//  */

/// The main Inerface for the system
///
/// Exprected to take an array of str from an RPC call
/// and to then lex and extract semantic information
/// pre passing this information on to the rest
/// of the system.
#[dojo::interface]
trait IListener {
    fn listen(ref world: IWorldDispatcher, cmd: Array<ByteArray>, p_id: felt252);

    // for interop with other worlds but doesnt have to be, could just be listen
    // but it sounds cooler
    fn command_shoggoth(
        ref world: IWorldDispatcher, victim: felt252, wish: Array<ByteArray>
    ) -> ByteArray;
}

/// Impl of the listener
/// acts as a main() and takes a command
/// which is then lexed and then has semantic
/// meaning extracted into a small struct
/// which can then be passed along to the next
/// logical block/system
#[dojo::contract]
pub mod meatpuppet {
    use super::{IListener};
    // use super::action_dispatcher as ad;
    use the_oruggin_trail::lib::verb_eater::verb_dispatcher as ad;
    use starknet::{ContractAddress, ClassHash, get_caller_address};
    use the_oruggin_trail::models::{output::{Output}, zrk_enums::{ActionType, ObjectType}};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};

    use the_oruggin_trail::constants::zrk_constants::ErrCode as ec;
    use the_oruggin_trail::lib::insult_meat::insulter as badmouth;
    use the_oruggin_trail::lib::err_handler::err_dispatcher as err_dispatch;

    use the_oruggin_trail::lib::store::{Store, StoreTrait};

    // use planetary_interface::interfaces::planetary::{
    //     PlanetaryInterface, PlanetaryInterfaceTrait, IPlanetaryActionsDispatcherTrait,
    // };

    // use planetary_interface::interfaces::tot::{ToTInterface, ToTInterfaceTrait,};

    fn dojo_init(ref world: IWorldDispatcher) {
        // let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        // planetary.dispatcher().register(ToTInterfaceTrait::NAMESPACE, world.contract_address);
    }

    #[abi(embed_v0)]
    impl ListenImpl of IListener<ContractState> {
        fn listen(ref world: IWorldDispatcher, cmd: Array<ByteArray>, p_id: felt252) {
            //! we use this as an error flag to kick us into error
            //! catching routines later as we run the parses over
            //! the command string
            let mut isErr: ec = ec::None;
            let l_cmd = @cmd;
            let l_cmd_cpy = l_cmd.clone();
            if l_cmd.len() >= 16 {
                // we have bad food make an error and pass along to
                // the error outputter system
                isErr = ec::BadLen;
                let mut wrld = world;
                err_dispatch::error_handle(ref wrld, p_id, isErr);
            } else {
                // grab the command stream array and extract a Garble type
                // for the game jam we want the fight command
                match confessor::confess(l_cmd_cpy) {
                    Result::Ok(r) => {
                        let out: ByteArray = "Shoggoth obeys....";
                        let mut wrld = world;
                        // we have a valid command so pass it into a handler routine
                        ad::handleGarble(ref wrld, p_id, r);
                    },
                    Result::Err(r) => {
                        let mut wrld = world;
                        err_dispatch::error_handle(ref wrld, p_id, isErr);
                    }
                }
            }
        }

        fn command_shoggoth(
            ref world: IWorldDispatcher, victim: felt252, wish: Array<ByteArray>
        ) -> ByteArray {
            // call into the main listen
            // the output is generated in the listen handler
            // which dispatches to the next handler etc
            // in other words hit main game loop
            println!("foolish desires: {:?}", wish);
            self.listen(wish, victim);

            // now read from the output model and exit
            let cmd_output: Output = get!(world, 23, Output);
            let shogoth_sees = cmd_output.text_o_vision;
            println!("{:?}", shogoth_sees);
            shogoth_sees
        }
    }
}

mod err_dispatcher {
    use the_oruggin_trail::constants::zrk_constants::ErrCode as ec;
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::lib::insult_meat::insulter as badmouth;
    use the_oruggin_trail::models::{output::{Output}};

    pub fn error_handle(ref world: IWorldDispatcher, err: ec, pid: felt252) {
        let bogus_cmd: Array<ByteArray> = array![];
        let speech = badmouth::opine_on_errors(err, @bogus_cmd);

        set!(world, Output { playerId: 23, text_o_vision: speech })
    }
}

