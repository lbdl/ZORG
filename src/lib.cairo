pub mod systems {
    pub mod outputter;
    pub mod meatpuppet;
    pub mod tokeniser;
    pub mod spawner;
}

pub mod constants {
    pub mod zrk_constants;
}

pub mod lib {
    pub mod insult_meat;
    pub mod hash_utils;
}

pub mod models {
    pub mod zrk_enums;
    pub mod output;
    pub mod player;
    pub mod txtdef;
    pub mod action;
    pub mod object;
    pub mod spawnroom;
    pub mod room;
}

pub mod tests {
    // pub mod test_world;
    pub mod test_meatpuppet_hearing;
    pub mod test_tokeniser;
    pub mod test_game_setup;
}
