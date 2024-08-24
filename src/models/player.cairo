use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Player {
    #[key]
    pub player_id: u32,
    pub player_adr: ContractAddress,
    pub location: felt252
}

