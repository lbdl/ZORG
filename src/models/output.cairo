use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
struct Output {
    #[key]
    playerId: ContractAddress,
    text: ByteArray
}
