mod tokeniser {
    use the_oruggin_trail::models::{
        zrk_enums::{ActionType, ObjectType, MaterialType, DirectionType}
    };

    fn str_to_AT(str: ByteArray) -> ActionType {
        if str == "move" || str == "go" {
            ActionType::Move
        } else if str == "look" {
            ActionType::Look
        } else if str == "kick" {
            ActionType::Kick
        } else {
            ActionType::None
        }
    }

    fn str_to_DT(str: ByteArray) -> DirectionType {
        if str == "north" {
            DirectionType::North
        } else if str == "south" {
            DirectionType::South
        } else if str == "east" {
            DirectionType::East
        } else if str == "west" {
            DirectionType::West
        } else if str == "up" {
            DirectionType::Up
        } else if str == "down" {
            DirectionType::Down
        } else {
            DirectionType::None
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
    use the_oruggin_trail::models::{
        zrk_enums::{ActionType, ObjectType, MaterialType, DirectionType}
    };
    use the_oruggin_trail::constants::zrk_constants;
    use super::tokeniser as lexer;

    /// Garble, the main semantic message type
    /// 
    /// it mainly is VRB, THING, THING (ie kick ball at troll)
    /// it can also be a MOVE, DIR (ie go north, or north) etc
    /// the later systems need to handle this specialisation
    #[derive(Serde, Copy, Drop, Introspect, Debug, PartialEq)]
    struct Garble {
        vrb: ActionType,
        dir: DirectionType,
        dobj: ObjectType,
        iobj: ObjectType,
    }

    fn confess(sin: Array<ByteArray>) -> Result<Garble, felt252> {
        // get the first token from the command
        let snap = @sin;
        let i0 = snap.at(0);
        let s0 = i0.clone();
        let t0 = lexer::str_to_AT(s0);

        // now handle the semantic analysis
        match t0 {
            ActionType::Move => { handle_moves(snap) },
            ActionType::Look => { Result::Err(zrk_constants::BAD_IMPL) },
            ActionType::None => { Result::Err(zrk_constants::BAD_IMPL) },
            _ => { Result::Err(zrk_constants::BAD_IMPL) },
        }
    }

    fn handle_moves(cmd: @Array<ByteArray>) -> Result<Garble, felt252> {
        Result::Err(zrk_constants::BAD_IMPL)
    }
}
