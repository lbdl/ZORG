use the_oruggin_trail::models::prayers::Prayer;

#[dojo::interface]
trait IListening {
    fn listen(command: Array<felt252>) -> Result<Prayer, felt252>;
}


#[dojo::contract]
mod listening {
    use super::{IListening};
    use starknet::{ContractAddress, get_caller_address};
    use the_oruggin_trail::models::{
        ears::{Ears}, 
        output::{Output}, 
        zrk_enums::{ActionType, ObjectType},
        prayers::{ Prayer }
    };

    #[abi(embed_v0)]
    impl ListenImpl of IListening<ContractState> {
        fn listen(world: @IWorldDispatcher, command: Array<felt252>) -> Result<Prayer, felt252> {
            if command.len() >= 16 {
                Err('TOK len >= 16')
            } else {
                let player = get_caller_address();
                Ok(Prayer{
                    playerId: player,
                    vrb: ActionType::Smash,
                    dobj: ObjectType::Door,
                    iobj: ObjectType::None,  
                })
            }
        }
    }
}