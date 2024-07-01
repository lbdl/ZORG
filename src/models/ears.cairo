use starknet::ContractAddress;
use the_oruggin_trail::models::zrk_enums::{ActionType, ObjectType};


// not sure we actually need this model
// as we handle in the listener 
// TODO: probably drop the model because
// we should end up with a `prayaer` to pass around
#[derive(Drop, Serde)]
#[dojo::model]
struct Ears {
    #[key]
    playerId: ContractAddress,
    input_stream: Array<felt252> 
}