use the_oruggin_trail::models::{
    prayers::Prayers,
    zrk_enums::{ActionType, ObjectType, MaterialType},
    tokens:: { ActionTokens }
};


#[dojo::interface]
trait ITokeniser {
    fn str_to_AT(str: felt252) -> ActionType;
    fn setup_types();
}

#[dojo::contract]
mod tokeniser {
    use super::ITokeniser;
    use the_oruggin_trail::models:: {
        zrk_enums::{ActionType, ObjectType, MaterialType}
    };

    // struct WrappedEnum {
    //     value: ActionType,
    // }

    // impl Felt252DictValue for WrappedEnum {
    //     fn zero_default() -> Self {
    //         WrappedEnum { value: MyEnum::Variant1 } // Default value
    //     }
    // }

    #[storage]
    struct Storage {
        has_setup: bool,
    }


    #[abi(embed_v0)]
    impl TokeniseImpl of ITokeniser<ContractState> {
        fn str_to_AT(world: @IWorldDispatcher, str: felt252) -> ActionType {
           
           // look up the token from the model 
            ActionType::None
        }
        
        fn setup_types(world: @IWorldDispatcher) {

        } 
    }


    // initialiser for overlay
    #[abi(embed_v0)]
    fn dojo_init() {
        println!("init....");
        let actions = array![
            'move',
            'look',
            'kick',
            'hit'
            ];
    }
    
}

