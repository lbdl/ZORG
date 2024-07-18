use the_oruggin_trail::models::{zrk_enums as zrk};

/// Objects are both Objects/things and now Direction things
/// like doors etc
#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct Object {
    #[key]
    objectId: felt252,
    objType: zrk::ObjectType,
    dirType: zrk::DirectionType, 
    destId: felt252,
    matType: zrk::MaterialType,
    objectActionIds: Array<felt252>,
    txtDefId: felt252
}