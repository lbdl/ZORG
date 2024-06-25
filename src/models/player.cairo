use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Player {
    #[key]
    playerId: u32,
    player_address: ContractAddress,
}

