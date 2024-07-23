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
        room::{Room}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    use the_oruggin_trail::constants::zrk_constants::{roomid as rm, statusid as st};

    use the_oruggin_trail::lib::hash_utils::hashutils as h_util;

 
    #[abi(embed_v0)]
    impl SpawnerImpl of ISpawner<ContractState> {
        fn setup(world: @IWorldDispatcher) {
            make_rooms(world, 23);
        }
    }

    fn make_rooms(w: IWorldDispatcher, pl: felt252) {
        //pass
        let p_id = pass_gen(w, pl);
    }

    fn barn_gen(w: IWorldDispatcher, playerid: felt252) {
        let pass_desc: ByteArray = "a high mountain pass that winds along...";
    }

    fn pass_gen(w: IWorldDispatcher, playerid: felt252) {
        // make an open action for the path west
        // and store it on the world
        // probs should be a txt_def
        // TODO a_id should be a hash
        let mut a_west = Action{actionId: st::NONE, actionType: zrk::ActionType::Open, 
            dBitTxt: "the path winds west, it is open", enabled: true, 
            revertable: false, dBit: true, 
            affectsActionId: 0, affectedByActionId: 0};
        
        let a_id = h_util::action_hash(@a_west);
        a_west.actionId = a_id;
        store_actions(w, array![a_west]);

        // now add this action id to a path object
        let path_desc: ByteArray = "path";
        let td_id_p = h_util::str_hash(@path_desc); // text

        let dest_name: ByteArray = "bensons plain";
        //! if you change this then regenerate the p_hash
        //! for the MockObjectImpl by uncommenting the
        //! println!() in the obj_hash function
        let mut p_west = Object{
            objectId: st::NONE, 
            objType: zrk::ObjectType::Path, 
            dirType: zrk::DirectionType::West, 
            destId: h_util::str_hash(@dest_name), 
            matType: zrk::MaterialType::Dirt,
            objectActionIds: array![a_id],
            txtDefId: td_id_p 
         };

        let d_id = h_util::obj_hash(@p_west); 
        p_west.objectId = d_id;
        store_txt(w, td_id_p, d_id, "path");
        store_objects(w, array![p_west]);

         // now store a room with all its shizzle
        let pass_desc: ByteArray = make_txt(rm::PASS);
        let _txt_id = h_util::str_hash(@pass_desc);
        let place_name: ByteArray = "walking eagle pass";
        let rmid = h_util::str_hash(@place_name);

        let mut place = Room{
            roomId: rmid,
            roomType: zrk::RoomType::Mountains,
            txtDefId: _txt_id,
            shortTxt: place_name,
            objectIds: array![],
            dirObjIds: array![d_id],
            players: array![]
        };

        // set main description text in world store
        // for the place/area/room
        store_txt(w, _txt_id, rmid, pass_desc);
        store_places(w, array![place]);
    }

    fn make_txt(id: felt252) -> ByteArray {
        if id == rm::PASS {
            "a high mountain pass that winds along..."
        } else {
            "nothing, empty space, you slowly dissolve to nothingness..."
        }
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

    fn store_places(w: IWorldDispatcher, t: Array<Room>) {
        let mut i = 0;
        while i < t.len() {
            let a: Room = t.at(i).clone();
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

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, val: ByteArray) {
        set!(world, (Txtdef { id: id, owner: ownedBy, text: val },));
    }
   
}
