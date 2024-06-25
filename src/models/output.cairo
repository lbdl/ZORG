use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Output {
    #[key]
    playerId: u32,
    text: felt252,
}

