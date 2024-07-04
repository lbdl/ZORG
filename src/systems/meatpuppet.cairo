use the_oruggin_trail::models::prayers::Prayers;

// we are gonna need the tokeniser system to convert types
// include here and we will need the dispatcher traits as

#[dojo::interface]
trait IListener {
    fn listen(cmd: Array<ByteArray>) -> Result<Prayers, felt252>;
}


#[dojo::contract]
mod meatpuppet {
    use super::{IListener};
    use starknet::{ContractAddress, get_caller_address};
    use the_oruggin_trail::models::{
        ears::{Ears}, 
        output::{Output}, 
        zrk_enums::{ActionType, ObjectType},
        prayers::{ Prayers }
    };

    #[abi(embed_v0)]
    impl ListenImpl of IListener<ContractState> {
        fn listen(world: @IWorldDispatcher, cmd: Array<ByteArray>) -> Result<Prayers, felt252> {
            let player = get_caller_address();
            if cmd.len() >= 16 {
                Result::Err('TOK len >= 16')
            } else {
                // call out to tokeniser and check error type
                Result::Ok(Prayers{
                    playerId: player,
                    vrb: ActionType::Smash,
                    dobj: ObjectType::Door,
                    iobj: ObjectType::None,  
                })
            }
        }
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