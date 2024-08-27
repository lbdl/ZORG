use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// we can add models here to make custom getters and setters etc
use the_oruggin_trail::models::{
    output::{ Output, OutputStore, OutputEntity, OutputEntityStore },
};

#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: IWorldDispatcher) -> Store {
        (Store { world: world })
    }

    //
    // Getters
    //

    #[inline(always)]
    fn get_output(self: Store, p_id: u128) -> Challenge {
        // (get!(self.world, duel_id, (Challenge)))
        // dojo::model::ModelEntity::<ChallengeEntity>::get(self.world, 1); // OK
        // let mut challenge_entity = ChallengeEntityStore::get(self.world, 1); // OK
        // challenge_entity.update(self.world); // ERROR
        (OutputStore::get(self.world, playerId))
    }
    
    //
    // Setters
    //
    #[inline(always)]
    fn set_output(self: Store, challenge: Challenge) {
        // set!(self.world, (challenge));
        // challenge.set(world); // ERROR
        dojo::model::Model::<Output>::set(@output, self.world);
    }



}