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

    

    #[abi(embed_v0)]
    impl SpawnerImpl of ISpawner<ContractState> {
        fn setup(world: @IWorldDispatcher) {
            make_pass(world);
        }
    }

    fn make_pass(w: IWorldDispatcher) {
        let desc_l: ByteArray = "foopy poopy doopy pathy wathy";
        let desc_s: ByteArray = "a mountain pass";

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