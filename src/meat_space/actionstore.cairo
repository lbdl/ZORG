use the_oruggin_trail::models::{zrk_enums as zrk};

#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct ActionStore {
    #[key]
    actionId: felt252,
    actionType: zrk::ActionType,
    dBitTxt: felt252, // when the bit is set then output this
    enabled: bool,
    revertable: bool,
    dBit: bool,
    affectsActionId: felt252,
    affectedByActionId: felt252
}