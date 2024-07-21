use the_oruggin_trail::models::{zrk_enums as zrk};

#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct Room{
    #[key]
    roomId: felt252,
    roomType: zrk::RoomType,
    txtDefId: felt252,
    shortTxt: ByteArray,
    objectIds: Array<felt252>,
    dirObjIds: Array<felt252>,
    players: Array<felt252>
}

