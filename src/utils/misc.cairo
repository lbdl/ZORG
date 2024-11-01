
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

// use debug::PrintTrait;
use starknet::{ContractAddress};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

#[inline(always)]
pub fn ZERO() -> ContractAddress {
    (starknet::contract_address_const::<0x0>())
}

#[inline(always)]
pub fn WORLD(_world: IWorldDispatcher) {}