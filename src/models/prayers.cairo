use starknet::ContractAddress;
use the_oruggin_trail::models::zrk_enums::{ActionType, ObjectType};

#[derive(Drop, Serde)]
#[dojo::model]
struct Prayer {
    #[key]
    playerId: ContractAddress,
    vrb: ActionType,
    dobj: ObjectType,
    iobj: ObjectType
}