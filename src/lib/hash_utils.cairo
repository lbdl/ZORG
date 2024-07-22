mod hashutils {
    
    use core::traits::Into;
use core::clone::Clone;
use core::poseidon::PoseidonTrait;
    use core::poseidon::poseidon_hash_span;
    use core::hash::{HashStateTrait, HashStateExTrait};

    use the_oruggin_trail::models::{
        room::{Room}, 
        object::{Object},
        action::{Action},
        zrk_enums::{MaterialType, ObjectType, ActionType, TxtDefType, DirectionType, RoomType, BiomeType}
    };


    /// ObjectType hashing
    /// 
    /// Should/can it be a trait? Probably
    /// We hash all the values othert than objectId as this
    /// is returned and we then store the object with this
    /// i.e. h => h(obj.*; if obj.* != id) 
    fn obj_hash(obj: @Object) -> felt252 {
        // convert enums to felts
        let local: Object = obj.clone();
        // let o_t: felt252 = local.objType.into();
        // let d_t: felt252 = local.dirType.into();
        let m_t: felt252 = local.matType.into();

        let mut hash = PoseidonTrait::new()
                        .update(local.objType.into())
                        .update(local.dirType.into())
                        .update(local.matType.into())
                        .update(local.destId)
                        .update(local.txtDefId)
                        .update(poseidon_hash_span(local.objectActionIds.span()))
                        .finalize();
        hash
    }

    fn action_hash(vrb: @Action) -> felt252 {
        666
    }

    fn ba_to_felt(in : @ByteArray) -> Array<felt252> {
        let local = in.clone();
        let l = local.len();
        println!("in: {:?} len: {:?}", local, l);
        let mut idx = 0;
        let mut arr_felt: Array<felt252> = ArrayTrait::new();
        
        while idx < l {
            // println!("{:?}, {:?}", idx, local);
            let f: felt252 = local.at(idx).unwrap().into();
            println!("{:?} {:?}", idx, f);
            arr_felt.append(f);
            idx += 1;
        };
        arr_felt
    }

    fn str_hash(txt: @ByteArray) -> felt252 {

        let local = txt.clone();
        let l = local.len();
        let mut idx = 0;
        let mut arr_felt: Array<felt252> = ba_to_felt(@local);
        
        // while idx < l {
        //     // println!("{:?}, {:?}, {:?}", idx, local, l);
        //     let f: felt252 = local.at(idx).unwrap().into();
        //     // println!("f: {:?}", f);
        //     arr_felt.append(f);
        //     idx += 1;
        // };

        let hash = PoseidonTrait::new().update(poseidon_hash_span(arr_felt.span())).finalize(); 
        hash
    }
}