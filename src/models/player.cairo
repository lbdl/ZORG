use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Player {
    #[key]
    player_id: u32,
    player_adr: ContractAddress,
    location: felt252
}

