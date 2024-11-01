
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

// /*
//  * Created on Thu Sep 05 2024
//  *
//  * Copyright (c) 2024 Archetypal Tech
//  * MeaCulpa (mc) 2024 lbdl | itrainspiders
//  */

// use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
pub struct Output {
    #[key]
    pub playerId: felt252,
    pub text_o_vision: ByteArray,
}
