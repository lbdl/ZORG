use the_oruggin_trail::models::zrk_enums::{ActionType};

#[derive(Copy, Drop, PartialEq, Introspect, Debug)]
enum ErrCode {
    BadLen,                      // input len >16 || 0
    BadFood,                     // input has no useable tokens
    BadImpl,                     // thing not implemented      
    BadMove: ActionType,     // no direction given         
    BadLook: ActionType,     // no object given            
    NulCmdO: ActionType,     // no object given to action 
    NulCmdI: ActionType,     // no i-object given to action
    None,                       // success, handly sometimes
}