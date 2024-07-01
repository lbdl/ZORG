use starknet::ContractAddress;
use the_oruggin_trail::models::zrk_enums::{ActionType, ObjectType};

#[derive(Drop, Serde)]
#[dojo::model]
struct Prayers {
    #[key]
    playerId: ContractAddress,
    vrb: ActionType,
    dobj: ObjectType,
    iobj: ObjectType
}