mod hashutils {
    
    use core::poseidon::PoseidonTrait;
    use core::poseidon::poseidon_hash_span;
    use core::hash::{HashStateTrait, HashStateExTrait};

    use the_oruggin_trail::models::{
        room::{Room}, 
        object::{Object},
        action::{Action}
    };

    fn obj_hash(obj: @Object) -> felt252 {
        666
    }

    fn action_hash(vrb: @Action) -> felt252 {
        666
    }

    fn str_hash(txt: @ByteArray) -> felt252 {

        let local = txt.clone();
        let l = local.len();
        let mut idx = 0;
        let mut arr_felt: Array<felt252> = ArrayTrait::new();
        
        while idx < l {
            idx += 1;
            let f: felt252 = local.at(idx).unwrap().into();
            arr_felt.append(f);
        };

        let hash = PoseidonTrait::new().update(poseidon_hash_span(arr_felt.span())).finalize(); 
        hash
    }
}