use the_oruggin_trail::models::zrk_enums::{ActionType};

#[derive(Copy, Drop, PartialEq, Introspect, Debug)]
pub enum ErrCode {
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
pub mod roomid {
  pub const  NONE: felt252 = 0 ;
  pub const  PASS: felt252 =  1;
  pub const  FORGE: felt252 =  2;
  pub const  BARN: felt252 =  3;
  pub const  PLAIN: felt252 =  4;
  pub const  BASEMENT: felt252 =  5; 
}

pub mod flags {
    pub const DEBUG: bool = true;
}

pub mod statusid {
    pub const NONE: felt252 = 0;
}