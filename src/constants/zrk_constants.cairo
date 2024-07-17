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

/// Room Codes
/// 
/// used for setup calls right now
mod roomid {
   const  NONE: felt252 = 0 ;                     // success, handly sometimes
   const  PASS: felt252 =  1;                    // input len >16 || 0
   const  FORGE: felt252 =  2;                    // input has no useable tokens
   const  BARN: felt252 =  3;                   // thing not implemented      
   const  PLAIN: felt252 =  4; 
   const  BASEMENT: felt252 =  5; 
}