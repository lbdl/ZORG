#[dojo::interface]
trait ISpawner {
    fn setup();
}


#[dojo::contract]
mod spawner {

    use super::ISpawner;

    use the_oruggin_trail::models::{
        zrk_enums as zrk,
        txtdef::{Txtdef}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    

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
        let pass_desc: ByteArray = "a high mountain pass that winds along...";
        let rmid = zc::roomid::PASS;
        store_txt(w, 23, rmid, pass_desc);
    }

    fn make_txt(w: IWorldDispatcher, id :felt252, owner: felt252, txt: ByteArray, ) {
        let desc_l: ByteArray = "a high mountain pass that winds along...";

        store_txt(w, 23, 20, desc_l);
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