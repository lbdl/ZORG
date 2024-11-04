
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

#[cfg(test)]
pub mod test_rig {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::traits::Into;

    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, WorldStorageTrait, WorldStorage};
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};

    use the_oruggin_trail::models::{
        output::{m_Output},
        action::{m_Action},
        room::{m_Room},
        object::{m_Object},
        player::{m_Player},
        txtdef::{m_Txtdef},
        inventory::{m_Inventory}
    };

    use the_oruggin_trail::systems::meatpuppet::{ 
        meatpuppet, 
        IListenerDispatcher, 
        IListenerDispatcherTrait 
    };

    use the_oruggin_trail::systems::spawner::{ 
        ISpawnerDispatcher, 
        ISpawnerDispatcherTrait 
    };

    use the_oruggin_trail::lib::store::{Store, StoreTrait}; 

    pub fn ZERO() -> ContractAddress { starknet::contract_address_const::<0x0>() }
    pub fn OWNER() -> ContractAddress { starknet::contract_address_const::<0x1>() }
    pub fn OTHER() -> ContractAddress { starknet::contract_address_const::<0x2>() }


    fn namespace_def() -> NamespaceDef {
        let ns: ByteArray = "the_oruggin_trail";
        let ndef = NamespaceDef {
            namespace: ns, resources: [
                TestResource::Model(m_Output::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Action::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Room::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Object::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Player::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Txtdef::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Model(m_Inventory::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Contract(
                    ContractDefTrait::new(actions::TEST_CLASS_HASH, "spawner")
                        .with_writer_of([dojo::utils::bytearray_hash(@ns)].span())
                ),
            ].span()
        };
        ndef
    }
 
    // set_contract_address : to define the address of the calling contract,
    // set_account_contract_address : to define the address of the account used for the current transaction.
    fn impersonate(address: ContractAddress) {
        testing::set_contract_address(address);
        testing::set_account_contract_address(address);
    }

    #[derive(Copy, Drop)]
    pub struct Systems {
        pub world: WorldStorage,
        pub listener: IListenerDispatcher,
        pub spawner: ISpawnerDispatcher
    }

    #[inline(always)]
    pub fn deploy_system(world: WorldStorage, contract: @ByteArray) -> ContractAddress {
        let (contract_address, _) = world.dns(contract).unwrap();
        (contract_address)
    }

    pub fn setup_world() -> Systems {
        // deploy world, models, systems etc
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        // deploy systems and set OWNER on the systems we want so we can write through
        let tot_listen = IListenerDispatcher{ contract_address:
            {
                let address = deploy_system(world, @"meatpuppet");
                (address)
            }
        };

        let tot_spawner = ISpawnerDispatcher{ contract_address:
            {
                let address = deploy_system(world, @"spawner");
                (address)
            }
        };
        

        let store: Store = StoreTrait::new(world);

        (Systems{
            world,
            listener:tot_listen,
            spawner:tot_spawner,
        })
    }

}