#[dojo::interface]
trait ISpawner {
    fn setup();
}


#[dojo::contract]
mod spawner {
    use core::byte_array::ByteArrayTrait;
use core::array::ArrayTrait;
    use core::option::OptionTrait;
    use super::ISpawner;

    use the_oruggin_trail::models::{
        zrk_enums as zrk, txtdef::{Txtdef}, action::{Action}, object::{Object},
        spawncount::{Spawncount}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    use the_oruggin_trail::constants::zrk_constants::roomid as rm;

    use core::poseidon::PoseidonTrait;
    use core::poseidon::poseidon_hash_span;
    use core::hash::{HashStateTrait, HashStateExTrait};

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
            ( Spawncount{ id: 666, a_c: 0, d_c: 0, o_c: 0, t_c: 0 } )
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
        // // KPATH -> W
        // uint32 open_2_west = createAction(ActionType.Open, "the path is passable", true, true, false, 0, 0);
        // uint32[MAX_OBJ] memory path_actions;
        // path_actions[0] = open_2_west;

        // uint32[MAX_OBJ] memory dirObjs;
        // uint32[MAX_OBJ] memory objs;
        let mut actions: Array<Action> = ArrayTrait::new();        
        
        let rmid = zc::roomid::PASS;
        let pass_desc: ByteArray = make_txt(rmid);
        let _txt_id = str_hash(@pass_desc);

        // set main description text in world store
        // for the place/area/room
        store_txt(w, _txt_id, rmid, pass_desc);

        // make an open action for the path west
        // and store it on the world
        // probs should be a txt_def
        let a_id = gen_action_id(w);
        let a_west = Action{actionId: a_id, actionType: zrk::ActionType::Open, 
            dBitTxt: "the path winds west, it is open", enabled: true, 
            revertable: false, dBit: true, 
            affectsActionId: 0, affectedByActionId: 0};
        
        store_actions(w, array![a_west]);

        // now add this action id to a path object
        // might be better as another hash from properties
        let d_id = gen_door_id(w); // owner 

        let path_desc = "path";
        let td_id_p = str_hash(@path_desc); // text
        
        store_txt(w, td_id_p, d_id, "path");

        let p_west = Object{
            objectId: d_id, 
            objType: zrk::ObjectType::Path, 
            dirType: zrk::DirectionType::West, 
            destId: zc::roomid::PLAIN, 
            matType: zrk::MaterialType::Dirt,
            objectActionIds: array![a_id],
            txtDefId: td_id_p 
         };

         store_objects(w, array![p_west]);

         // now store a room with all its shizzle

        //  let r_pass = Object {
        //     objectId: d_id, 
        //     objType: zrk::ObjectType::Path, 
        //     dirType: zrk::DirectionType::West, 
        //     destId: zc::roomid::PLAIN, 
        //     matType: zrk::MaterialType::Dirt,
        //     objectActionIds: array![a_id],
        //     txtDefId: td_id_p
        //  }

    }

    fn make_txt(id: felt252) -> ByteArray {
        if id == rm::PASS {
            "a high mountain pass that winds along..."
        } else {
            "nothing, empty space, you slowly dissolve to nothingness..."
        }
    }

    fn str_hash(txt: @ByteArray) -> felt252 {

        let local = txt.clone();
        let l = local.len();
        let mut idx = 0;
        let mut arr_felt: Array<felt252> = ArrayTrait::new();
        
        while idx < l {
            idx += 1;
            let f: felt252 = local.at(idx).unwrap().into();
            arr_felt.append(f);
        };

        let hash = PoseidonTrait::new().update(poseidon_hash_span(arr_felt.span())).finalize(); 
        hash
    }

    fn store_objects(w: IWorldDispatcher, t: Array<Object>) {
        let mut i = 0;
        while i < t.len() {
            let a: Object = t.at(i).clone();
            set!(w, (a));
            i += 1 + i;
        }
    }

    fn store_actions(w: IWorldDispatcher, t: Array<Action>) {
        let mut i = 0;
        while i < t.len() {
            let a: Action = t.at(i).clone();
            set!(w, (a));
            i += 1 + i;
        }
    }

    // fn store<T, +Clone<T>, +Drop<T>, +Serde<T> >(w: IWorldDispatcher, t: Array<T>) {
    //     let mut i = 0;
    //     while i < t.len() {
    //         let a = t.at(i).clone();
    //         set!(w, (a));
    //         i += 1 + i;
    //     }
    // }


    // fn store_direction(
    //     dir: zrk::DirectionType,
    //     id: felt252,
    //     d_type: zrk::ObjectType,
    //     mat: zrk::MaterialType,
    //     txt: ByteArray,
    //     actionIds: Array<felt252>
    // ) {}

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, val: ByteArray) {
        set!(world, (Txtdef { id: id, owner: ownedBy, text: val },));
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
            Spawncount{id: 666, a_c: ac, d_c: sc.d_c, o_c: sc.o_c, t_c: sc.t_c},
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
            Spawncount{id: 666, a_c: sc.a_c, d_c: dc, o_c: sc.o_c, t_c: sc.t_c},
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
            Spawncount{id: 666, a_c: sc.a_c, d_c: sc.d_c, o_c: oc, t_c: sc.t_c},
        ));
        oc
    }
    
    fn gen_txt_id(w: IWorldDispatcher) -> felt252 {
        //! this should be genetic over a T like enum but
        //! am unsure how to implement, probably by a trait 
        //! that returns a comparable value rather than a variant ?
        let sc: Spawncount = get!(w, 666, (Spawncount));
        let mut tc = sc.t_c;
        tc += 1;
        set!(w, (
            Spawncount{id: 666, a_c: sc.a_c, d_c: sc.d_c, o_c: sc.o_c, t_c: tc},
        ));
        tc
    }


}
