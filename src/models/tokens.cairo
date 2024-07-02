use the_oruggin_trail::models::zrk_enums::{ ActionType, ObjectType };

#[derive(Drop, Serde)]
#[dojo::model]
struct ActionTokens {
    #[key]
    tok_str: felt252,
    tok_val: ActionType
}

#[derive(Drop, Serde)]
#[dojo::model]
struct ObjectTokens {
    #[key]
    tok_str: felt252,
    tok_val: ObjectType
}

