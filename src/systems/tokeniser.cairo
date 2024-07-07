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
        } else if s == "look" || s == "examine" || s == "stare" {
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
        } else if s == "troll" {
            ObjectType::Troll
        } else {
            ObjectType::None
        }
    }
}

mod confessor {
    use the_oruggin_trail::models::{
        zrk_enums::{ActionType, ObjectType, MaterialType, DirectionType}
    };
    use the_oruggin_trail::constants::zrk_constants as e;
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

    /// The Confessor - mumble your shameful desires here and receive a message
    /// 
    /// the main entrance of the parsing system, takes an array of str
    /// and then lexes and runs semantic analysis on the lexed tokens
    /// to extract meaning and create a simple message type that can be
    /// passed around the system logic to make things happen in the world
    fn confess(sin: Array<ByteArray>) -> Result<Garble, felt252> {
        // get the first token from the command
        let snap = @sin;
        let i0 = snap.at(0);
        let s0 = i0.clone();
        let t0 = lexer::str_to_AT(s0);

        // now handle the semantic analysis
        match t0 {
            ActionType::Move => { parse_moves(snap) },
            ActionType::Look => { parse_look(snap) },
            ActionType::None => { Result::Err(e::BAD_IMPL) },
            _ => { parse_action(snap, t0) },
        }
    }

    /// General VERBS
    /// 
    /// non movement and loooking verbs, i.e the general case 
    fn parse_action(cmd: @Array<ByteArray>, at: ActionType) -> Result<Garble, felt252> {
        let mut do: ObjectType = ObjectType::None;
        let mut io: ObjectType = ObjectType::None;

        let s = cmd.at(cmd.len() - 1);
        let s0 = s.clone();
        let do = lexer::str_to_OT(s0);

        let lng_frm = cmd.len() > 3;

        if do == ObjectType::None {
            Result::Err(e::NUL_CMD_OBJ)
        } else if do != ObjectType::None && !lng_frm {
            Result::Ok(
                Garble { vrb: at, dir: DirectionType::None, dobj: do, iobj: ObjectType::None, }
            )
        } else {
            Result::Err(e::BAD_IMPL)
        }

        Result::Err(e::BAD_IMPL)
    }

    /// LOOK command
    /// 
    /// can be LOOK or LOOK AT THING, EXAMINE THING
    fn parse_look(cmd: @Array<ByteArray>) -> Result<Garble, felt252> {
        //! LOOK is a single action but it can be specialised to look at things
        let s = cmd.at(cmd.len() - 1);
        let s0 = s.clone();
        let t0 = lexer::str_to_OT(s0);

        if t0 != ObjectType::None {
            Result::Ok(
                Garble {
                    vrb: ActionType::Look,
                    dir: DirectionType::None,
                    dobj: t0,
                    iobj: ObjectType::None,
                }
            )
        } else {
            Result::Ok(
                Garble {
                    vrb: ActionType::Look,
                    dir: DirectionType::None,
                    dobj: ObjectType::None,
                    iobj: ObjectType::None,
                }
            )
        }
    }

    /// MOVE/GO commands
    /// 
    /// can be GO TO THE NORTH, NORTH, GO NORTH, MOVE NORTH etc
    fn parse_moves(cmd: @Array<ByteArray>) -> Result<Garble, felt252> {
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
            Result::Err(e::BAD_MOVE)
        } else {
            Result::Ok(
                Garble {
                    vrb: ActionType::Move, dir: t, dobj: ObjectType::None, iobj: ObjectType::None
                }
            )
        }
    }
}
