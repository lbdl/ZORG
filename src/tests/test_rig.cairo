#[cfg(test)]
mod test_rig {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::traits::Into;
    // use array::ArrayTrait;
    // use debug::PrintTrait;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::utils::test::{spawn_test_world, deploy_contract};

    use the_oruggin_trail::models::{
        output::{output, Output}
    };

    use the_oruggin_trail::systems::meatpuppet::{ 
        meatpuppet, 
        IListenerDispatcher, 
        IListenerDispatcherTrait 
    };
    
    use the_oruggin_trail::lib::store::{Store, StoreTrait}; 

    fn ZERO() -> ContractAddress { starknet::contract_address_const::<0x0>() }
    fn OWNER() -> ContractAddress { starknet::contract_address_const::<0x1>() }
    fn OTHER() -> ContractAddress { starknet::contract_address_const::<0x2>() }
 
    // set_contract_address : to define the address of the calling contract,
    // set_account_contract_address : to define the address of the account used for the current transaction.
    fn impersonate(address: ContractAddress) {
        testing::set_contract_address(address);
        testing::set_account_contract_address(address);
    }

    #[derive(Copy, Drop)]
    struct Systems {
        world: IWorldDispatcher,
        actions: IListenerDispatcher,
        store: Store,
    }

    #[inline(always)]
    fn deploy_system(world: IWorldDispatcher, salt: felt252, class_hash: felt252) -> ContractAddress {
        let contract_address = world.deploy_contract(salt, class_hash.try_into().unwrap());
        (contract_address)
    }

    fn setup_world(flags: u8) -> Systems {

        let mut models = array![
            output::TEST_CLASS_HASH,
        ];

        // deploy world, models, systems etc
        let namespace: ByteArray = "the_oruggin_trail";
        let ns: ByteArray = namespace.clone();
        let namespaces = [namespace];
        let world: IWorldDispatcher = spawn_test_world(namespaces.span(),  models.span());

        // allow us OWNER over stuff 
        world.grant_owner(dojo::utils::bytearray_hash(@ns), OWNER());
        // world.contract_address.print();

        // deploy systems and set OWNER on the systems we want so we can write through
        let tot_systems = IListenerDispatcher{ contract_address:
            {
                let address = deploy_system(world, 'meatpuppet', meatpuppet::TEST_CLASS_HASH);
                world.grant_owner(dojo::utils::bytearray_hash(@ns), address);
                (address)
            }
        };

        
        impersonate(OWNER());

        let store: Store = StoreTrait::new(world);

        (Systems{
            world,
            actions:tot_systems,
            store,
        })
    }

}