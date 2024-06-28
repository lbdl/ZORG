use starknet::ContractAddress;
use the_oruggin_trail::models::zrk_enums{MaterialType};

#[derive(drop, Serde)]
#[dojo::model]
struct Ears {
    #[key]
    playerId: ContractAddress,
    input_stream: Array<felt252> 
}

struct Prayer {
    vrb: zrk_enums::ActionType,
    dobj: zrk_enums::ObjectType,
    iobj: zrk_enums::ObjectType
}