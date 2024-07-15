// use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
struct Output {
    #[key]
    playerId: felt252,
    text_o_vision: ByteArray,
}
