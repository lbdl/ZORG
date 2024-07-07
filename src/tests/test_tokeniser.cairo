#[cfg(test)]
mod tests {
    use the_oruggin_trail::{
        systems::{
            tokeniser::{tokeniser, confessor, confessor::Garble}
            },
        models::{
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType}
        },
        constants::{zrk_constants as e}
    };

    // LEX tests
    #[test]
    fn test_lexer_actions() {
        let bad_str: ByteArray = "foo";
        let good_str: ByteArray = "move";
        let tok_good = tokeniser::str_to_AT(good_str);
        let tok_none = tokeniser::str_to_AT(bad_str);
        assert(tok_good == ActionType::Move, 'expected MOVE');
        assert(tok_none == ActionType::None, 'expected NONE');
    }
    
    #[test]
    fn test_lexer_objects() {
        let bad_str: ByteArray = "foo";
        let good_str: ByteArray = "ball";
        let tok_good = tokeniser::str_to_OT(good_str);
        let tok_none = tokeniser::str_to_OT(bad_str);
        assert(tok_good == ObjectType::Ball, 'expected BALL');
        assert(tok_none == ObjectType::None, 'expected NONE');
    }
    
    // MOVE tests
    #[test]
    fn test_sem_action_bad_parse() {
        let bad_str: ByteArray = "foo";
        let _in: Array<ByteArray> = array![bad_str];
        let actual: Result<Garble, felt252> = confessor::confess(_in);
        assert_eq!(actual, Result::Err(e::BAD_IMPL), "Expected err got {:?}", actual) 
    }

    #[test]
    fn test_sem_move_parse_long() {
        let str_m: ByteArray = "go";
        let str_p: ByteArray = "to";
        let str_pp: ByteArray = "the";
        let str_d: ByteArray = "north";
        let _in: Array<ByteArray> = array![str_m, str_p, str_pp, str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Move, dir: DirectionType::North, dobj: ObjectType::None, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }
    
    #[test]
    fn test_sem_move_parse_short() {
        let str_d: ByteArray = "north";
        let _in: Array<ByteArray> = array![str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Move, dir: DirectionType::North, dobj: ObjectType::None, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

    #[test]
    fn test_sem_move_parse_badfood() {
        let str_d: ByteArray = "go";
        let _in: Array<ByteArray> = array![str_d];
        let expected = Result::Err(e::BAD_MOVE);
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

   // LOOK tests 
    #[test]
    fn test_sem_look_parse_short() {
        let str_v: ByteArray = "look";
        let _in: Array<ByteArray> = array![str_v];
        let expected = Result::Ok(Garble{vrb: ActionType::Look, dir: DirectionType::None, dobj: ObjectType::None, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    } 
    
    #[test]
    fn test_sem_look_parse_long() {
        let str_v: ByteArray = "look";
        let str_d: ByteArray = "around";
        let _in: Array<ByteArray> = array![str_v, str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Look, dir: DirectionType::None, dobj: ObjectType::None, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    } 

    #[test]
    fn test_sem_look_parse_thing() {
        let str_v: ByteArray = "look";
        let str_p: ByteArray = "at";
        let str_d: ByteArray = "troll";
        let _in: Array<ByteArray> = array![str_v, str_p, str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Look, dir: DirectionType::None, dobj: ObjectType::Troll, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

    #[test]
    fn test_sem_look_parse_examine() {
        let str_v: ByteArray = "examine";
        let str_d: ByteArray = "troll";
        let _in: Array<ByteArray> = array![str_v, str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Look, dir: DirectionType::None, dobj: ObjectType::Troll, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

    // ACTION tests
    #[test]
    fn test_sem_action_parse_dobj() {
        //! kick the ball at the window
        let str_v: ByteArray = "kick";
        let str_d: ByteArray = "ball";
        let _in: Array<ByteArray> = array![str_v, str_d];
        let expected = Result::Ok(Garble{vrb: ActionType::Kick, dir: DirectionType::None, dobj: ObjectType::Ball, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }
    
    #[test]
    fn test_sem_action_parse_dobj_iobj() {
        //! kick the ball at the window
        let str_v: ByteArray = "kick";
        let str_d: ByteArray = "ball";
        let str_a: ByteArray = "the";
        let str_pp: ByteArray = "at";
        let str_a2: ByteArray = "the";
        let str_io: ByteArray = "window";
        let _in: Array<ByteArray> = array![str_v, str_d, str_a, str_pp, str_a2, str_io];
        let expected = Result::Ok(
            Garble{
                vrb: ActionType::Kick, 
                dir: DirectionType::None, 
                dobj: ObjectType::Ball, 
                iobj: ObjectType::Window
            }
        );
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

    #[test]
    fn test_sem_action_parse_no_obj() {
        //! kick the ball at the window
        let str_v: ByteArray = "kick";
        let _in: Array<ByteArray> = array![str_v];
        let expected = Result::Err(e::NUL_CMD_OBJ);
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }

    #[test]
    fn test_sem_action_parse_garbage() {
        //! kick the ball at the window
        let str_v: ByteArray = "kick";
        let str_d: ByteArray = "ball";
        let str_p: ByteArray = "at";
        let str_io: ByteArray = "foop";
        let _in: Array<ByteArray> = array![str_v, str_d, str_p, str_io];
        let expected = Result::Ok(Garble{vrb: ActionType::Kick, dir: DirectionType::None, dobj: ObjectType::Ball, iobj: ObjectType::None});
        let actual: Result<Garble, felt252> = confessor::confess(_in); 
        assert_eq!(actual, expected, "Expected {:?} got {:?}", expected, actual);
    }
}