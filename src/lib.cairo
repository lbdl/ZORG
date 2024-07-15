mod systems {
    mod actions;
    mod outputter;
    mod meatpuppet;
    mod tokeniser;
    mod spawner;
}

mod constants {
    mod zrk_constants;
}

mod lib {
    mod insult_meat;
}

mod meat_space {
    mod actionstore;
    mod roomstore;
    mod txtdefstore;
    mod objectstore;
    mod playerstore;
    // mod dirstore;
}

mod models {
    mod moves;
    mod position;
    mod zrk_enums;
    mod output;
    mod player;
}

mod tests {
    mod test_world;
    mod test_meatpuppet_hearing;
    mod test_tokeniser;
    mod test_game_setup;
}
