/// The main Inerface for the system
///
/// Exprected to take an array of str from an RPC call
/// and to then lex and extract semantic information
/// pre passing this information on to the rest
/// of the system.
#[dojo::interface]
trait IListener {
    fn listen(ref world: IWorldDispatcher, cmd: Array<ByteArray>, p_id: felt252);
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
    use super::action_dispatcher as ad;
    use starknet::{ContractAddress, ClassHash, get_caller_address};
    use the_oruggin_trail::models::{output::{Output}, zrk_enums::{ActionType, ObjectType}};
    use the_oruggin_trail::systems::tokeniser::{tokeniser as lexer, confessor, confessor::Garble};

    use the_oruggin_trail::constants::zrk_constants::ErrCode as ec;
    use the_oruggin_trail::lib::insult_meat::insulter as badmouth;
    use super::err_dispatcher as err_dispatch;

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
                err_dispatch::error_handle(ref wrld, isErr, p_id);
            } else {
                // grab the command stream array and extract a Garble type
                // for the game jam we want the fight command
                match confessor::confess(l_cmd_cpy) {
                    Result::Ok(r) => {
                        let out: ByteArray = "Shoggoth obeys....";
                        let mut wrld = world;
                        // we have a valid command so pass it into a handler routine
                        ad::handleGarble(ref wrld, r);
                    },
                    Result::Err(r) => { 
                        let mut wrld = world;
                        err_dispatch::error_handle(ref wrld, isErr, p_id);
                    }
                }
            }
        }
    }
}


mod interop_dispatcher {
use dojo::world::{IWorldDispatcher};

    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait,
        IVulcanSaluteDispatcher, IVulcanSaluteDispatcherTrait,
    };
    
    use planetary_interface::interfaces::pistols64::{
        Pistols64Interface, Pistols64InterfaceTrait,
        IPistols64ActionsDispatcher, IPistols64ActionsDispatcherTrait,
    };

    pub fn live_long(world: @IWorldDispatcher) -> felt252 {
        println!("------------->live_long");
        let vulcan: IVulcanSaluteDispatcher = VulcanInterfaceTrait::new().dispatcher();
        println!("vulcan::live_long------------>");
        (vulcan.live_long())
    }    

    pub fn kick_off(world: @IWorldDispatcher) -> u128 {
        println!("------------->create_challenge");
        let pistols: IPistols64ActionsDispatcher = Pistols64InterfaceTrait::new().dispatcher();
        println!("pistols::create_challenge------------->");
        (pistols.create_challenge('gandalf', 'elron', 'FIGHT'))
    }
}

mod action_dispatcher {
    use super::interop_dispatcher as interop;
    use the_oruggin_trail::systems::tokeniser::confessor::{Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::models::{output::{Output}, zrk_enums::{ActionType, ObjectType}};

    pub fn handleGarble(ref world: IWorldDispatcher, msg: Garble) {
        println!("HNDL: ---> {:?}", msg.vrb);
        let mut out: ByteArray = "Shogoth is loveable by default";
        let mut i_out: u128 = 0;
        // let mut i_out: felt252;
        match msg.vrb {
            ActionType::Look => { out = "Shoggoth stares into the void" },
            ActionType::Fight => { 
                println!("STARTING A FIGHT LIKE A MAN");
                // i_out = interop::live_long(@world) 
                i_out = interop::kick_off(@world); 
                if ( i_out > 0 ) {
                    println!("pistols:------->{:?}", i_out);
                    out = "Returned from pistols";   
                }
            },
            _ => { out = "Shoggoth understands the void and the formless action" },
        }
        set!(world, Output { playerId: 23, text_o_vision: out });
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
        set!(world, Output { playerId: 23, text_o_vision: speech });
    }

}
