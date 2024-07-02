use the_oruggin_trail::models::{
    prayers::Prayers,
    zrk_enums::{ActionType, ObjectType, MaterialType},
    tokens:: { ActionTokens }
};


#[dojo::interface]
trait ITokeniser {
    // fn str_to_MT(str: ByteArray) -> MaterialType;
    fn str_to_AT(str: felt252) -> ActionType;
    // fn str_to_OT(str: ByteArray) -> ObjectType;
}

#[dojo::contract]
mod tokeniser {
    use super::ITokeniser;
    use the_oruggin_trail::models:: {
        zrk_enums::{ActionType, ObjectType, MaterialType}
    };

    #[abi(embed_v0)]
    impl TokeniseImpl of ITokeniser<ContractState> {
        fn str_to_AT(world: @IWorldDispatcher, str: felt252) -> ActionType {
           // look up the token from the model 
            ActionType::None
        }
    } 
    
}

