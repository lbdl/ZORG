use the_oruggin_trail::models::{zrk_enums::{ActionType, ObjectType, MaterialType}};

mod tokeniser {
    use the_oruggin_trail::models::{zrk_enums::{ActionType, ObjectType, MaterialType}};

    fn str_to_AT(str: ByteArray) -> ActionType {
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

    fn str_to_OT(str: ByteArray) -> ObjectType {
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

mod confessor {
    use the_oruggin_trail::models::{zrk_enums::{ActionType, ObjectType, MaterialType}};
    use super::tokeniser as lexer;

    #[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
    struct Garble {
      vrb: ActionType,
      dobj: ObjectType,
      iobj: ObjectType,
    }

    fn confess(sin: Array<ByteArray>) -> Result<Garble, felt252> {

      // get the first token from the command
      let snap = @sin;
      let i0 = snap.at(0);
      let s0 = i0.clone();
      let t0 = lexer::str_to_AT(s0);



      Result::Err('impl_me_now')
    }
}
