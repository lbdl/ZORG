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
// }
}

