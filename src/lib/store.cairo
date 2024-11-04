
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

use dojo::world::{IWorldDispatcher, WorldStorage, WorldStorageTrait};
use dojo::model::{ModelStorage};

// we can add models here to make custom getters and setters etc
use the_oruggin_trail::models::{
    output::{ Output},
};

#[derive(Copy, Drop)]
pub struct Store {
    world: IWorldDispatcher,
    world_store: WorldStorage,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: IWorldDispatcher) -> Store {
        (Store { 
            world: world, 
            world_store: WorldStorageTrait::new(world, @"the_oruggin_trail") })
    }

    //
    // Getters
    //

    #[inline(always)]
    fn get_output(self: Store, p_id: felt252) -> Output {
        self.world_store.read_model(23)
    }
    
    //
    // Setters
    //
    #[inline(always)]
    fn set_output(mut self: Store, pid: felt252, msg: ByteArray) {
        let output: Output = Output{ playerId: pid, text_o_vision: msg };
        self.world_store.write_model(@output);
    }

}