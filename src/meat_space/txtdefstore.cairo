use the_oruggin_trail::models::{zrk_enums as zrk};

#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct TxtDefStore {
    #[key]
    txtDefId: felt252,
    owner: felt252, // grab the mat type from the owning object
    txtDefType: zrk::TxtDefType,
    value: ByteArray
}