use the_oruggin_trail::models::{zrk_enums as zrk};

#[derive(Copy, Drop, Serde, PartialEq, Introspect, Debug)]
#[dojo::model]
struct Dirs {
    #[key]
    key: felt252,
    dir: zrk::DirectionType,
    tok: ByteArray
}









// Vrbs: {
//     keySchema: {
//         val: "ActionType",
//     },
//     valueSchema: {
//         dirType: "string",
//     },
// },
// RoomStore: { // add
//     keySchema: {
//         roomId: "uint32",
//     },
//     valueSchema: {
//         roomType: "RoomType",
//         txtDefId: "bytes32",
//         description: "string", //temp
//         objectIds: "uint32[32]",
//         dirObjIds: "uint32[32]",
//         players: "uint32[32]"
//     },
// }