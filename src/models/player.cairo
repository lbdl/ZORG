use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Player {
    #[key]
    player_adr: ContractAddress,
    player_id: u32,
}

