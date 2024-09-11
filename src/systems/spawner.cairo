#[dojo::interface]
trait ISpawner<T> {
    fn setup(ref world: IWorldDispatcher);
}


#[dojo::contract]
pub mod spawner {
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
        fn setup(ref world: IWorldDispatcher) {
            make_rooms(world, 23);
        }
    }

    fn make_rooms(w: IWorldDispatcher, pl: felt252) {
        //pass
        let _ = pass_gen(w, pl);
        let _ = plain_gen(w, pl);
        // let _ = barn_gen(w, pl);
    }

    fn plain_gen(w: IWorldDispatcher, playerid: felt252) {
        // make an open action for the path east
        // and store it on the world
        // ACTION open east
        let mut a_east = Action{actionId: st::NONE, actionType: zrk::ActionType::Open, 
            dBitTxt: "the path winds east, it is open", enabled: true, 
            revertable: false, dBit: true, 
            affectsActionId: 0, affectedByActionId: 0};
        
        let ae_id = h_util::action_hash(@a_east);
        a_east.actionId = ae_id;

        // ACTION open north
        let mut a_north = Action{
            actionId: st::NONE, 
            actionType: zrk::ActionType::Open, 
            dBitTxt: "the path heads north, it leads to a barn", enabled: true, 
            revertable: false, dBit: true, 
            affectsActionId: 0, affectedByActionId: 0};
        
        let an_id = h_util::action_hash(@a_north);
        a_north.actionId = an_id;
        store_actions(w, array![a_east, a_north]);

        // now add the east open to door to the mountains
        // door/path are used interchangeably in the code
        let path_desc: ByteArray = "a path east leads upwards toward the mountains";
        let td_id_p = h_util::str_hash(@path_desc); // text id

        let east_dest_name: ByteArray = "walking eagle pass";
        let mut p_east = Object{
            objectId: st::SETME, 
            objType: zrk::ObjectType::Path, 
            dirType: zrk::DirectionType::East, 
            destId: h_util::str_hash(@east_dest_name), 
            matType: zrk::MaterialType::Dirt,
            objectActionIds: array![ae_id],
            txtDefId: td_id_p 
         };

        let de_id = h_util::obj_hash(@p_east); 
        p_east.objectId = de_id;
        store_txt(w, td_id_p, de_id, path_desc);
        
        // now add the north open to door to the barn
        // door/path are used interchangeably in the code
        let north_path_desc: ByteArray = "a path north leads toward a large wooden barn";
        let td_id_pn = h_util::str_hash(@north_path_desc); // text id

        let north_dest_name: ByteArray = "eli's barn";
        let mut p_north = Object{
            objectId: st::SETME, 
            objType: zrk::ObjectType::Path, 
            dirType: zrk::DirectionType::North, 
            destId: h_util::str_hash(@north_dest_name), 
            matType: zrk::MaterialType::Dirt,
            objectActionIds: array![an_id],
            txtDefId: td_id_pn 
         };

        let dn_id = h_util::obj_hash(@p_north); 
        p_north.objectId = dn_id;
        store_txt(w, td_id_pn, dn_id, north_path_desc);

        // now we have assembled 2 path objects and stored
        // their components we can store the paths themselves
        store_objects(w, array![p_east, p_north]);

        // now the football
        
        //kick action for the ball
        let mut a_kick = Action{actionId: st::NONE, actionType: zrk::ActionType::Kick, 
            dBitTxt: "the ball bounces feebly and rolls into some dog shit. fun.", enabled: true, 
            revertable: false, dBit: true, 
            affectsActionId: 0, affectedByActionId: 0};
        
        let ak_id = h_util::action_hash(@a_kick);
        a_kick.actionId = ak_id;
        store_actions(w, array![a_kick]);

        let mut football = Object{
            objectId: st::SETME, 
            objType: zrk::ObjectType::Ball, 
            dirType: zrk::DirectionType::None, 
            destId: st::NONE,
            matType: zrk::MaterialType::Leather,
            objectActionIds: array![ak_id],
            txtDefId: st::SETME 
         };

        let ball_id = h_util::obj_hash(@football); 
        football.objectId = ball_id;
        let ball_desc: ByteArray = "a knock off UEFA football\nits a bit battered and bruised\nnot exactly a sphere\nbut you can kick it";
        let td_id_b = h_util::str_hash(@ball_desc); // text id
        football.txtDefId = td_id_b;

        store_txt(w, td_id_b, ball_id, ball_desc);
        store_objects(w, array![football]);

          // now store a room with all its shizzle
        let plain_desc: ByteArray = make_txt(rm::PLAIN);
        let _txt_id = h_util::str_hash(@plain_desc);
        let place_name: ByteArray = "bensons plain";
        let rmid = h_util::str_hash(@place_name);

        let mut place = Room{
            roomId: rmid,
            roomType: zrk::RoomType::Plain,
            txtDefId: _txt_id,
            shortTxt: place_name,
            objectIds: array![ball_id],
            dirObjIds: array![de_id, dn_id],
            players: array![]
        };

        // set main description text in world store
        // for the place/area/room
        store_txt(w, _txt_id, rmid, plain_desc);
        store_places(w, array![place]);

    }

    fn barn_gen(w: IWorldDispatcher, playerid: felt252) {
        // let pass_desc: ByteArray = "a high mountain pass that winds along...";
    }

    fn pass_gen(w: IWorldDispatcher, playerid: felt252) {
        // make an open action for the path west
        // and store it on the world
        // probs should be a txt_def
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
            objectId: st::SETME, 
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
            "it winds through the mountains, the path is treacherous\ntoilet papered trees cover the steep \nvalley sides below you.\nOn closer inspection the TP might \nbe the remains of a cricket team\nor perhaps a lost and very dead KKK picnic group.\nIt's brass monkeys."
        } else if id == rm::PLAIN {
            "the plain reaches seemingly endlessly to the sky in all directions\nand the sky itself feels greasy and cold.\npyramidal rough shapes dot the horizin and land which\nupon closer examination are made from bufalo skulls.\nThe air tastes of grease and bensons.\nhappy happy happy\n"
        } else {
            "nothing,\nempty space,\nyou slowly dissolve to nothingness..."
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
