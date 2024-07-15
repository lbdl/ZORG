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
    use the_oruggin_trail::meat_space::meat_world::{
        Dirs,
        RoomStore,
        ActionStore,
        ObjectStore,
        TxtDefStore,
        Player
    };

    #[abi(embed_v0)]
    impl SpawnImpl of ISetup<ContractState> {
        fn spawn(world: @IWorldDispatcher) {

        }
    }    
}