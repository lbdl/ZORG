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

#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct DirObjStore {
    #[key]
    dirObjId: felt252,
    objType: zrk::ObjectType,
    dirType: zrk::DirectionType, 
    matType: zrk::MaterialType,
    destId: felt252,
    txtDefId: felt252,
    objectActionIds: Array<felt252>
}


// ObjectStore: {
//     keySchema: {
//         objectId: "uint32",
//     },
//     valueSchema: {
//         objectType: "ObjectType",
//         materialType: "MaterialType",
//         txtDefId: "bytes32",
//         objectActionIds: "uint32[32]",
//         description: "string"
//     },
// },