use the_oruggin_trail::models::{zrk_enums as zrk};

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Action {
    #[key]
   pub actionId: felt252,
   pub actionType: zrk::ActionType,
   pub dBitTxt: ByteArray, // when the bit is set then output this
   pub enabled: bool,
   pub revertable: bool,
   pub dBit: bool,
   pub affectsActionId: felt252,
   pub affectedByActionId: felt252
}

pub fn action_mock_hash() -> felt252 {
    570569841135745306506513556879415971252297628232229127693536224532629374082
}