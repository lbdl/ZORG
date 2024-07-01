use the_oruggin_trail::models::prayers::Prayers;

#[dojo::interface]
trait IListener {
    fn listen(cmd: Array<ByteArray>) -> Result<Prayers, felt252>;
}


#[dojo::contract]
mod listener {
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
                Result::Ok(Prayers{
                    playerId: player,
                    vrb: ActionType::Smash,
                    dobj: ObjectType::Door,
                    iobj: ObjectType::None,  
                })
            }
        }
    }

}