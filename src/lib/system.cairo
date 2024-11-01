
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

use starknet::{ContractAddress, ClassHash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource, WorldStorage, WorldStorageTrait};

use the_oruggin_trail::utils::misc::{ZERO};
pub use the_oruggin_trail::generated::spawner::{ISpawnerDispatcher, ISpawnerDispatcherTrait};

// pub mod SELECTORS {
//    pub const SPAWNER: ByteArray = "spawner";
// }

#[generate_trait]
pub impl WorldSystemsTraitImpl of WorldSystemsTrait {
    fn contract_address(self: IWorldDispatcher, selector: @ByteArray) -> ContractAddress {
        let world: WorldStorage = WorldStorageTrait::new(self, @"the_oruggin_trail");
        if let Option::Some((address, _)) = world.dns(selector) {
            (address)
        } else {
            (ZERO())
        }
    }

    fn spawner_dispatcher(self: IWorldDispatcher) -> ISpawnerDispatcher {
        (ISpawnerDispatcher{ contract_address: self.contract_address(@"spawner") })
    }
}
