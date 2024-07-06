#[cfg(test)]
mod tests {
    use the_oruggin_trail::{
        systems::{
            tokeniser::{tokeniser, confessor, confessor::Garble}
            },
        models::{
            zrk_enums::{MaterialType, ActionType, ObjectType}
        },
        constants::{zrk_constants as e}
    };

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

    #[test]
    fn test_sem_action_bad_parse() {
        let bad_str: ByteArray = "foo";
        let _in: Array<ByteArray> = array![bad_str];
        let actual: Result<Garble, felt252> = confessor::confess(_in);
        assert_eq!(actual, Result::Err(e::BAD_IMPL), "Expected err got {:?}", actual) 
    }
}