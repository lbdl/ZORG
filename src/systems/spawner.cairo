#[dojo::interface]
trait ISpawner {
    fn setup();
}


#[dojo::contract]
mod spawner {
    use core::option::OptionTrait;
    use super::ISpawner;

    use the_oruggin_trail::models::{
        zrk_enums as zrk, txtdef::{Txtdef}, action::{Action}, object::{Object},
        spawncount::{Spawncount}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    use the_oruggin_trail::constants::zrk_constants::roomid as rm;


    // fn dojo_init(w: IWorldDispatcher) {
    //     set!(world, (SpawnCount { id: 666, a_c: 0, d_c: 0, o_c: 0 },))
    // }

    #[abi(embed_v0)]
    impl SpawnerImpl of ISpawner<ContractState> {
        fn setup(world: @IWorldDispatcher) {
            init_counter(world);
            make_rooms(world, 23);
        }
    }

    fn init_counter(w: IWorldDispatcher) {
        set!(
            w,
            ( {Spawncount{ id: 666, a_c: 0, d_c: 0, o_c: 0 }}, )
        )
    }

    fn make_rooms(w: IWorldDispatcher, pl: felt252) {
        //pass
        pass_gen(w, pl);
    // barn_gen(w, pl);
    }

    fn barn_gen(w: IWorldDispatcher, playerid: felt252) {
        let pass_desc: ByteArray = "a high mountain pass that winds along...";
    }

    fn pass_gen(w: IWorldDispatcher, playerid: felt252) {
        let rmid = zc::roomid::PASS;
        let pass_desc: ByteArray = make_txt(rmid);
        store_txt(w, rmid, rmid, pass_desc);

        let a_id = gen_action_id(w);
        let d_id = gen_door_id(w);
        let o_id = gen_obj_id(w);
    // let a_west = Action{actionId:  };

    }

   /// Counters
   /// 
   /// Used to increment an id for a given action which is then used to 
   /// access that from other systems. Needs to be set at init but this
   /// should be some kind of automated post deploy type thing anyway 
   /// 
   /// We hav 3 functions and it should be a generic over a type like the
   /// enums we have defined
    fn gen_action_id(w: IWorldDispatcher) -> felt252 {
        //! this should be genetic over a T like enum but
        //! am unsure how to implement, probably by a trait 
        //! that returns a comparable value rather than a variant ?
        let sc: Spawncount = get!(w, 666, (Spawncount));
        let mut ac = sc.a_c;
        ac += 1;
        set!(w, (
            Spawncount{id: 666, a_c: ac, d_c: sc.d_c, o_c: sc.o_c},
        ));
        ac
    }
    
    fn gen_door_id(w: IWorldDispatcher) -> felt252 {
        //! this should be genetic over a T like enum but
        //! am unsure how to implement, probably by a trait 
        //! that returns a comparable value rather than a variant ?
        let sc: Spawncount = get!(w, 666, (Spawncount));
        let mut dc = sc.d_c;
        dc += 1;
        set!(w, (
            Spawncount{id: 666, a_c: sc.a_c, d_c: dc, o_c: sc.o_c},
        ));
        dc
    }
 
    fn gen_obj_id(w: IWorldDispatcher) -> felt252 {
        //! this should be genetic over a T like enum but
        //! am unsure how to implement, probably by a trait 
        //! that returns a comparable value rather than a variant ?
        let sc: Spawncount = get!(w, 666, (Spawncount));
        let mut oc = sc.o_c;
        oc += 1;
        set!(w, (
            Spawncount{id: 666, a_c: sc.a_c, d_c: sc.d_c, o_c: oc},
        ));
        oc
    }


    fn make_txt(id: felt252) -> ByteArray {
        if id == rm::PASS {
            "a high mountain pass that winds along..."
        } else {
            "nothing, empty space, you slowly dissolve to nothingness..."
        }
    }

    fn store_action(
        vrb: zrk::ActionType,
        desc: ByteArray,
        enabled: bool,
        dBit: bool,
        revert: bool,
        affects: felt252,
        afftectedBy: felt252
    ) {}


    fn store_direction(
        dir: zrk::DirectionType,
        id: felt252,
        d_type: zrk::ObjectType,
        mat: zrk::MaterialType,
        txt: ByteArray,
        actionIds: Array<felt252>
    ) {}

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, val: ByteArray) {
        set!(world, (Txtdef { id: id, owner: ownedBy, text: val },));
    }
}
