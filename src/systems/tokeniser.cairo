use the_oruggin_trail::models::{
    prayers::Prayers,
    zrk_enums::{ActionType, ObjectType, MaterialType},
    tokens:: { ActionTokens }
};


#[dojo::interface]
trait ITokeniser {
    fn str_to_AT(str: ByteArray) -> ActionType;
    fn str_to_OT(str: ByteArray) -> ObjectType;
    // fn str_to_felt(str: ByteArray) -> felt252;
}

#[dojo::contract]
mod tokeniser {
    use super::ITokeniser;
    use the_oruggin_trail::models:: {
        zrk_enums::{ActionType, ObjectType, MaterialType}
    };

    #[abi(embed_v0)]
    impl TokeniseImpl of ITokeniser<ContractState> {
        fn str_to_AT(world: @IWorldDispatcher, str: ByteArray) -> ActionType {
          if str == "move" {
            ActionType::Move
          } else if str == "look" {
            ActionType::Look
          } else if str == "kick" {
            ActionType::Kick
          } else {
            ActionType::None
          }
        }

        fn str_to_OT(world: @IWorldDispatcher, str: ByteArray) -> ObjectType {
          if str == "ball" {
            ObjectType::Ball
          } else if str == "window" {
            ObjectType::Window
          } else if str == "door" {
            ObjectType::Door
          } else {
            ObjectType::None
          }
        }
    }
}

