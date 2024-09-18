use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// we can add models here to make custom getters and setters etc
use the_oruggin_trail::models::{
    output::{ Output, OutputStore, OutputEntity, OutputEntityStore },
};

#[derive(Copy, Drop)]
pub struct Store {
    world: IWorldDispatcher,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: IWorldDispatcher) -> Store {
        (Store { world: world })
    }

    //
    // Getters
    //

    #[inline(always)]
    fn get_output(self: Store, p_id: felt252) -> Output {
        // (get!(self.world, duel_id, (Challenge)))
        // dojo::model::ModelEntity::<ChallengeEntity>::get(self.world, 1); // OK
        // let mut challenge_entity = ChallengeEntityStore::get(self.world, 1); // OK
        // challenge_entity.update(self.world); // ERROR
        // (OutputStore::get(self.world, playerId)) // ERROR
        // dojo::model::Model::<Output>::get(self.world, 23)
        get!( self.world, 23, Output )
    }
    
    //
    // Setters
    //
    #[inline(always)]
    fn set_output(self: Store, pid: felt252, msg: ByteArray) {
        let output: Output = Output{ playerId: pid, text_o_vision: msg };
        set!(self.world, (output));
        // output.set(world); // ERROR
        // dojo::model::Model::<Output>::set(@output, self.world);
    }



}