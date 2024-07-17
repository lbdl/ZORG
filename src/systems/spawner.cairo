#[dojo::interface]
trait ISpawner {
    fn setup();
}


#[dojo::contract]
mod spawner {

    use core::option::OptionTrait;
use super::ISpawner;

    use the_oruggin_trail::models::{
        zrk_enums as zrk,
        txtdef::{Txtdef}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    use the_oruggin_trail::constants::zrk_constants::roomid as rm;

    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    

    #[abi(embed_v0)]
    impl SpawnerImpl of ISpawner<ContractState> {
        fn setup(world: @IWorldDispatcher) {
            make_rooms(world, 23);
        }
    }

    fn make_rooms(w: IWorldDispatcher, pl: felt252    ) {
        //pass
        pass_gen(w, pl);
        // barn_gen(w, pl);
    }
    
    fn barn_gen(w: IWorldDispatcher, playerid: felt252) {
        let pass_desc: ByteArray = "a high mountain pass that winds along...";
    }
    
    fn pass_gen(w: IWorldDispatcher, playerid: felt252) {
        let rmid = zc::roomid::PASS;
        let pass_desc: ByteArray = make_txt(rmid);
        store_txt(w, rmid, rmid, pass_desc);
        
    }

    fn make_direction(id: felt252, dir: zrk::DirectionType, d_type: zrk::ObjectType, mat: zrk::MaterialType, txt: ByteArray,) {

    }

    fn make_txt(id: felt252) -> ByteArray {
        if id == rm::PASS {
            "a high mountain pass that winds along..."
        } else {
            "nothing, empty space, you slowly dissolve to nothingness..."
        }
    }    

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, val: ByteArray) {
        set!(
                world , (
                    Txtdef {
                        id: id,
                        owner: ownedBy,
                        text: val
                    },
                )
            );
    }
}