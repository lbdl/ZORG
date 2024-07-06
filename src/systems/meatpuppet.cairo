use the_oruggin_trail::models::prayers::Prayers;

// export a function for rpc calls
#[dojo::interface]
trait IListener {
    fn listen(cmd: Array<ByteArray>) -> Result<Prayers, felt252>;
}

#[dojo::contract]
mod meatpuppet {
    use super::{IListener};
    use starknet::{ContractAddress, ClassHash, get_caller_address};
    use the_oruggin_trail::models::{
        ears::{Ears}, 
        output::{Output}, 
        zrk_enums::{ActionType, ObjectType},
        prayers::{ Prayers }
    };
    use the_oruggin_trail::systems::tokeniser::{
        tokeniser as lexer, 
        confessor, 
        confessor::Garble};

    #[storage]
    struct Storage {
        tokeniser_adr: ContractAddress,
        tokeniser_cls: ClassHash,
    }

    #[abi(embed_v0)]
    impl ListenImpl of IListener<ContractState> {
        fn listen(world: @IWorldDispatcher, cmd: Array<ByteArray>) -> Result<Prayers, felt252> {
            let player = get_caller_address();
            if cmd.len() >= 16 {
                Result::Err('TOK len >= 16')
            } else {
                // grab the command stream array and extract a Garble type
                match confessor::confess(cmd){
                    Result::Ok(r) => {},
                    Result::Err(r) => {}
                }
                // let tok: ActionType = lexer::str_to_AT("move"); 
                Result::Ok(Prayers{
                    playerId: player,
                    vrb: ActionType::Move,
                    dobj: ObjectType::Door,
                    iobj: ObjectType::None,  
                })
            }
        }
    }

    fn dojo_init(
        world: @IWorldDispatcher,
        tokeinser_address: ContractAddress,
        tokeniser_class: ClassHash,
    ) {
        // TODO: add a model to store the systems we want to call
        // then set the values from here
    }


    fn fish_tokens(toks: Array<ByteArray>) -> Result<Prayers, felt252> {
        //chop out the first token.
        // this can be a VRB or a MVRB
        let pl = get_caller_address();

        

        let res = Prayers {
            playerId: pl,
            vrb: ActionType::None,
            dobj: ObjectType::None,
            iobj: ObjectType::None,
        };
        Result::Ok(res)
    }

}