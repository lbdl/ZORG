const SUCCESS:      felt252 = 0;    // all good!
const BAD_LEN:      felt252 = 1;    // input len >16 || 0
const BAD_FOOD:     felt252 = 2;    // input has no useable tokens      
const BAD_IMPL:     felt252 = 3;    // thing not implemented
const BAD_MOVE:     felt252 = 4;    // no direction given
const BAD_LOOK:     felt252 = 5;    // no object given
const NUL_CMD_OBJ:  felt252 = 6;    // no object given to action
const NUL_CMD_IOBJ: felt252 = 7;    // no i-object given to action