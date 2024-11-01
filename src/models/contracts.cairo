
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

use starknet::{ ContractAddress, ClassHash };

#[derive(Copy, Drop, Serde)]
#[dojo::event]
#[dojo::model]
pub struct ContractInitialized {
    #[key]
    pub contract_type: felt32,
    pub contract_address: ContractAddress,
    pub contract_class: ClassHash,
}