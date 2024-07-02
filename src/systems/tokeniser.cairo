use the_oruggin_trail::models::{
    prayers::Prayers,
    zrk_enums::{ActionType, ObjectType, MaterialType},
    tokens:: { ActionTokens }
};


#[dojo::interface]
trait ITokeniser {
    fn str_to_AT(str: felt252) -> ActionType;
    fn str_to_MT(str: felt252) -> MaterialType;
    fn str_to_OT(str: felt252) -> ObjectType;
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
          if str == 'move' {
            ActionType::Move
          } else if str == 'look' {
            ActionType::Look
          } else if str == 'kick' {
            ActionType::Kick
          } else {
            ActionType::None
          }
        }

        fn str_to_OT(world: @IWorldDispatcher, str: felt252) -> ObjectType {
          if str == 'ball' {
            ObjectType::Ball
          } else if str == 'window' {
            ObjectType::Window
          } else if str == 'door' {
            ObjectType::Door
          } else {
            ObjectType::None
          }
        
        }

        fn str_to_MT(world: @IWorldDispatcher, str: felt252) -> MaterialType {
          if str == 'wood' {
            MaterialType::Wood
          } else if str == 'dirt' {
            MaterialType::Dirt
          } else if str == 'glass' {
            MaterialType::Glass
          } else {
            MaterialType::None
          }
        }
 
    }
}

