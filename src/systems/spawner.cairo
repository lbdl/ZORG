#[dojo::interface]
trait ISetup {
    fn spawn();
}


#[dojo::contract]
mod spawner {

    use super::ISetup;
    use the_oruggin_trail::models::{
        zrk_enums as zrk
    };
    use the_oruggin_trail::meat_space::{
        roomstore::{RoomStore},
        actionstore::{ActionStore},
        txtdefstore::{TxtDefStore},
        objectstore::{ObjectStore},
        playerstore::{PlayerStore}
    };

    #[abi(embed_v0)]
    impl SpawnImpl of ISetup<ContractState> {
        fn spawn(world: @IWorldDispatcher) {
            // let desc_l: ByteArray = "foopy poopy doopy pathy wathy";
            // let desc_s: ByteArray = "a mountain pass";
            // set!(
            //     world , (
            //         TxtDefStore {
            //             txtDefId: 23,
            //             owner: 23,
            //             txtDefType: zrk::TxtDefType::Place,
            //             value: "FFOO BBAARR"
            //         },
            //     )
            // );

            make_pass(world);
        }
    }

    fn make_pass(w: IWorldDispatcher) {
        let desc_l: ByteArray = "foopy poopy doopy pathy wathy";
        let desc_s: ByteArray = "a mountain pass";

        store_txt(w, 23, 20, zrk::TxtDefType::Place, desc_l);

    }    

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, t: zrk::TxtDefType, val: ByteArray) {
        set!(
                world , (
                    TxtDefStore {
                        txtDefId: id,
                        owner: ownedBy,
                        txtDefType: t,
                        value: val
                    },
                )
            );
    }
}