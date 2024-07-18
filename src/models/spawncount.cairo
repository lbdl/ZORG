#[derive(Copy, Drop, Serde)]
    #[dojo::model]
    struct Spawncount {
        #[key]
        id: felt252,
        a_c: felt252,
        d_c: felt252,
        o_c: felt252,
    }