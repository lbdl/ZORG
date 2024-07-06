use starknet::{ ContractAddress, ClassHash };

#[derive(Copy, Drop, Serde)]
#[dojo::event]
#[dojo::model]
struct ContractInitialized {
    #[key]
    contract_type: felt32,
    contract_address: ContractAddress,
    contract_class: ClassHash,
}