mod tokeniser {
    use the_oruggin_trail::models::{
        zrk_enums::{ActionType, ObjectType, MaterialType, DirectionType}
    };

    fn str_to_AT(s: ByteArray) -> ActionType {
        if s == "move"
            || s == "go"
            || s == "north"
            || s == "south"
            || s == "east"
            || s == "west"
            || s == "up"
            || s == "down" {
            ActionType::Move
        } else if s == "look" {
            ActionType::Look
        } else if s == "kick" {
            ActionType::Kick
        } else {
            ActionType::None
        }
    }

    fn str_to_DT(s: ByteArray) -> DirectionType {
        if s == "north" || s == "n" {
            DirectionType::North
        } else if s == "south" || s == "s" {
            DirectionType::South
        } else if s == "east" || s == "e" {
            DirectionType::East
        } else if s == "west" || s == "w" {
            DirectionType::West
        } else if s == "up" {
            DirectionType::Up
        } else if s == "down" {
            DirectionType::Down
        } else {
            DirectionType::None
        }
    }

    fn str_to_OT(s: ByteArray) -> ObjectType {
        if s == "ball" {
            ObjectType::Ball
        } else if s == "window" {
            ObjectType::Window
        } else if s == "door" {
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
        let mut t: DirectionType = DirectionType::None;
        // we know we have a move type 
        if cmd.len() > 1 {
          //! long form movement command
            let s = cmd.at(cmd.len() - 1);
            let s0 = s.clone();
            t = lexer::str_to_DT(s0);
        } else {
          //! alias form movement command
            let s = cmd.at(0);
            let s0 = s.clone();
            t = lexer::str_to_DT(s0);
        }

        if t == DirectionType::None {
          Result::Err(zrk_constants::BAD_MOVE)
        } else {
              Result::Ok(Garble{vrb: ActionType::Move, dir: t, dobj: ObjectType::None, iobj: ObjectType::None})
        }
    }
}
