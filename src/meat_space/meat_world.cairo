use the_oruggin_trail::models::{zrk_enums as zrk};

/// we probably dont actually need this model
#[derive(Clone, Drop, Serde, PartialEq, Introspect, Debug)]
#[dojo::model]
struct Dirs {
    #[key]
    key: felt252,
    dir: zrk::DirectionType,
    tok: ByteArray
}

#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct RoomStore {
    #[key]
    roomId: felt252,
    roomType: zrk::RoomType,
    txtDefId: felt252,
    shortTxt: ByteArray,
    objectIds: Array<felt252>,
    dirObjIds: Array<felt252>,
    players: Array<felt252>
}


//     valueSchema: {
//         roomType: "RoomType",
//         txtDefId: "bytes32",
//         description: "string", //temp
//         objectIds: "uint32[32]",
//         dirObjIds: "uint32[32]",
//         players: "uint32[32]"
//     },
// }