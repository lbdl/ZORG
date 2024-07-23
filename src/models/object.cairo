use the_oruggin_trail::models::{zrk_enums as zrk};

/// Objects are both Objects/things and now Direction things
/// like doors etc
/// 
/// we should think about using this as the reverse door as well
/// maybe a flag in the setup functions that add the reverse mapping?
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

/// Returns the p has of the contents of the 
/// p_west Object in the Spawner::pass_gen function
/// just used for tests
fn obj_mock_hash() -> felt252 {
    2263872834238055898308204958742375141829104772912262985655433645762816310321
}
