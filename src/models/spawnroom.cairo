/// We put a set of room id's into the rooms
/// array and then use them to choose a spawn 
/// point for a user
#[derive(Clone, Drop, Serde)]
#[dojo::model]
struct Spawnroom {
    #[key]
    id: u32, // always 666
    rooms: Array<felt252>,
}