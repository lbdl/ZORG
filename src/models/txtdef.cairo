use the_oruggin_trail::models::zrk_enums as zrk;

#[derive(Drop, Serde, Clone)]
#[dojo::model]
struct Txtdef {
    #[key]
    id: felt252,
    owner: felt252,
    text: ByteArray 
}