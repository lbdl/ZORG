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
/// This should in fact be used by some codegen which
/// would create these consts based on the map array and
/// then later create the room object itself and as part of 
/// that process create the phash of the rooms properties and
/// set that back on the struct??
/// 
/// Or this is just a set of start positions 
mod roomid {
   const  NONE: felt252 = 0 ;
   const  PASS: felt252 =  1;
   const  FORGE: felt252 =  2;
   const  BARN: felt252 =  3;
   const  PLAIN: felt252 =  4;
   const  BASEMENT: felt252 =  5; 
}

mod flags {
    const DEBUG: bool = true;
}

mod statusid {
    const NONE: felt252 = 0;
}