pub mod interop_dispatcher {
    use dojo::world::{IWorldDispatcher};

    use planetary_interface::interfaces::vulcan::{
        VulcanInterface, VulcanInterfaceTrait, IVulcanSaluteDispatcher,
        IVulcanSaluteDispatcherTrait,
    };

    use planetary_interface::interfaces::pistols64::{
        Pistols64Interface, Pistols64InterfaceTrait, IPistols64ActionsDispatcher,
        IPistols64ActionsDispatcherTrait,
    };

    // pub fn live_long(world: @IWorldDispatcher) -> felt252 {
    //     println!("------------->live_long");
    //     let vulcan: IVulcanSaluteDispatcher = VulcanInterfaceTrait::new().dispatcher();
    //     println!("vulcan::live_long------------>");
    //     (vulcan.live_long())
    // }

    pub fn kick_off(world: @IWorldDispatcher) -> u128 {
        let pistols: IPistols64ActionsDispatcher = Pistols64InterfaceTrait::new().dispatcher();
        println!("pistols::create_challenge------------->");
        let ps_id: u128 = pistols.create_challenge('gandalf', 'elron', 'FIGHT');
        ps_id
    }
}