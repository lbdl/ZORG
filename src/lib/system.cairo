use starknet::{ContractAddress, ClassHash};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use the_oruggin_trail::utils::misc::{ZERO};
pub use the_oruggin_trail::systems::spawner::{ISpawnerDispatcher, ISpawnerDispatcherTrait};

pub mod SELECTORS {
   pub const SPAWNER: felt252 = selector_from_tag!("the_oruggin_trail-spawner");
}

#[generate_trait]
pub impl WorldSystemsTraitImpl of WorldSystemsTrait {
    fn contract_address(self: IWorldDispatcher, selector: felt252) -> ContractAddress {
        if let Resource::Contract((_, contract_address)) = self.resource(selector) {
            (contract_address)
        } else {
            (ZERO())
        }
    }

    // fn spawner_address(self: IWorldDispatcher) -> ContractAddress {
    //     (self.contract_address(SELECTORS::SPAWNER))
    // }

    fn spawner_dispatcher(self: IWorldDispatcher) -> ISpawnerDispatcher {
        (ISpawnerDispatcher{ contract_address: self.contract_address(SELECTORS::SPAWNER) })
    }
}
