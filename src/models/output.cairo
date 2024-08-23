// use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
pub struct Output {
    #[key]
    pub playerId: felt252,
    pub text_o_vision: ByteArray,
}
