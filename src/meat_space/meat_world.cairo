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
struct ActionStruct {
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


// // attach to rooms/paths to set the exits
// // give it a DirObjType like DOOR
// // then give it a directionType like NORTH
// // then give it an Action like OPEN or LOCKED
// // or BOTH!
// DirObjectStore: {
//     keySchema: {
//         dirObjId: "uint32",
//     },
//     valueSchema: {
//         objType: "DirObjectType", // Door/Window/CaveMouth etc
//         dirType: "DirectionType", // North, South, Up etc
//         matType: "MaterialType",
//         destId: "uint32",
//         txtDefId: "bytes32",
//         objectActionIds: "uint32[32]" // Open/Lock/Break etc
//     },
// },
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