#[dojo::interface]
trait ISpawner {
    fn setup(ref world: IWorldDispatcher);
    fn spawn_player(ref world: IWorldDispatcher, pid: felt252, start_room: felt252);
}


#[dojo::contract]
pub mod spawner {
    use starknet::{ContractAddress, testing, get_caller_address};
    use core::byte_array::ByteArrayTrait;
    use core::array::ArrayTrait;
    use core::option::OptionTrait;
    use super::ISpawner;

    use the_oruggin_trail::models::{
        zrk_enums as zrk, 
        txtdef::{Txtdef}, 
        action::{Action}, 
        object::{Object}, 
        room::{Room}, 
        player::{Player},
        inventory::{Inventory}
    };

    use the_oruggin_trail::constants::zrk_constants as zc;
    use the_oruggin_trail::constants::zrk_constants::{roomid as rm, statusid as st};

    use the_oruggin_trail::lib::hash_utils::hashutils as h_util;


    #[abi(embed_v0)]
    impl SpawnerImpl of ISpawner<ContractState> {
        fn setup(ref world: IWorldDispatcher) {
            make_rooms(world, 23);
        }

        fn spawn_player(ref world: IWorldDispatcher, pid: felt252, start_room: felt252) {
            let player = Player{
                player_id: pid,
                player_adr: OTHER(),
                location: start_room,
                inventory: pid
            };

            let inv = Inventory {owner_id: pid, items: array![]};
            set!(world, (inv));
            set!(world, (player));
        }
    }

    fn OTHER() -> ContractAddress { starknet::contract_address_const::<0x2>() }

    fn make_rooms(w: IWorldDispatcher, pl: felt252) {
        //pass
        let _ = pass_gen(w, pl);
        let _ = plain_gen(w, pl);
        let _ = barn_gen(w, pl);
        let _ = forge_gen(w, pl);
    }

    /// Bensons Plain
    /// open path east
    /// open path north
    /// 1 object: a football
    fn plain_gen(w: IWorldDispatcher, playerid: felt252) {
        // make an open action for the path east
        // and store it on the world
        // ACTION open east
        let mut a_east = Action {
            actionId: st::NONE,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the path winds east, it is open",
            enabled: true,
            revertable: false,
            dBit: true,
            affectsActionId: 0,
            affectedByActionId: 0
        };

        let ae_id = h_util::action_hash(@a_east);
        a_east.actionId = ae_id;

        // ACTION open north
        let mut a_north = Action {
            actionId: st::NONE,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the path heads north, it leads to a barn",
            enabled: true,
            revertable: false,
            dBit: true,
            affectsActionId: 0,
            affectedByActionId: 0
        };

        let an_id = h_util::action_hash(@a_north);
        a_north.actionId = an_id;
        store_actions(w, array![a_east, a_north]);

        // now add the east open to the mountains
        // door/path are used interchangeably in the code
        let path_desc: ByteArray = "a path east leads upwards toward the mountains";
        let td_id_p = h_util::str_hash(@path_desc); // text id

        let east_dest_name: ByteArray = "walking eagle pass";
        let mut p_east = Object {
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
        let mut p_north = Object {
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
        let mut a_kick = Action {
            actionId: st::NONE,
            actionType: zrk::ActionType::Kick,
            dBitTxt: "the ball bounces feebly and rolls into some dog shit. fun.",
            enabled: true,
            revertable: false,
            dBit: true,
            affectsActionId: 0,
            affectedByActionId: 0
        };

        let ak_id = h_util::action_hash(@a_kick);
        a_kick.actionId = ak_id;
        store_actions(w, array![a_kick]);

        let mut football = Object {
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
        let ball_desc: ByteArray =
            "a knock off UEFA football\nit's a bit battered and bruised and not exactly a sphere\nbut you can kick it";
        let td_id_b = h_util::str_hash(@ball_desc); // text id
        football.txtDefId = td_id_b;

        store_txt(w, td_id_b, ball_id, ball_desc);
        store_objects(w, array![football]);

        // now store a room with all its shizzle
        let plain_desc: ByteArray = make_txt(rm::PLAIN);
        let _txt_id = h_util::str_hash(@plain_desc);
        let place_name: ByteArray = "bensons plain";
        let rmid = h_util::str_hash(@place_name);

        let mut place = Room {
            roomId: rmid,
            roomType: zrk::RoomType::Plain,
            biomeType: zrk::BiomeType::Prarie,
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
    /// Elis Barn
    /// open door south
    /// closed window west
    /// mo objects
    fn barn_gen(w: IWorldDispatcher, playerid: felt252) {
        // WINDOW WEST actions
        // ACTION open west
        // its disabled and closed and non revertable
        // so it needs to be enabled by the action chain
        let mut a_west_open = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the window, now broken, falls open",
            enabled: false,
            dBit: false,
            revertable: false,
            affectsActionId: st::NONE,
            affectedByActionId: st::SETME
        };

        // ACTION smash west
        let mut a_west_smash = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Break,
            dBitTxt: "the window, smashes, glass flies everywhere, very very satisfying",
            enabled: true,
            dBit: false,
            revertable: false,
            affectsActionId: st::SETME,
            affectedByActionId: st::NONE
        };

        let a_open_id = h_util::action_hash(@a_west_open);
        let a_smash_id = h_util::action_hash(@a_west_smash);

        a_west_smash.actionId = a_smash_id;
        a_west_smash.affectsActionId = a_open_id;
        a_west_open.actionId = a_open_id;
        a_west_open.affectedByActionId = a_smash_id;

        // store the actions on the world
        store_actions(w, array![a_west_open, a_west_smash]);

        // DOOR SOUTH actions
        // ACTION open south
        let mut a_south_open = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the door, closes with a creak",
            enabled: true,
            dBit: true,
            revertable: false,
            affectsActionId: st::NONE,
            affectedByActionId: st::NONE
        };
        let a_open_south_id = h_util::action_hash(@a_south_open);
        a_south_open.actionId = a_open_south_id;

        // store the actions on the world
        store_actions(w, array![a_south_open]);

        // Now the exits
        // SOUTH DOOR
        let mut d_south = Object {
            objectId: st::SETME,
            objType: zrk::ObjectType::Door,
            dirType: zrk::DirectionType::South,
            destId: st::NONE,
            matType: zrk::MaterialType::Wood,
            objectActionIds: array![a_open_south_id],
            txtDefId: st::SETME
        };
        let dest_name_south: ByteArray = "bensons plain";
        let dest_south_id = h_util::str_hash(@dest_name_south);
        d_south.destId = dest_south_id;
        let d_south_id = h_util::obj_hash(@d_south);
        d_south.objectId = d_south_id;
        let south_desc: ByteArray = "an old wooden barn door, leads south";
        let td_id_south = h_util::str_hash(@south_desc);
        d_south.txtDefId = td_id_south;
        store_txt(w, td_id_south, d_south_id, south_desc);

        // WEST WINDOW
        let mut d_west = Object {
            objectId: st::SETME,
            objType: zrk::ObjectType::Window,
            dirType: zrk::DirectionType::West,
            destId: st::NONE,
            matType: zrk::MaterialType::Glass,
            objectActionIds: array![a_open_id, a_smash_id],
            txtDefId: st::SETME
        };
        let dest_name_west: ByteArray = "eli's forge";
        let dest_west_id = h_util::str_hash(@dest_name_west);
        d_west.destId = dest_west_id;
        let d_west_id = h_util::obj_hash(@d_west);
        d_west.objectId = d_west_id;
        let west_desc: ByteArray = "a dusty window, at chest height";
        let td_id_west = h_util::str_hash(@west_desc);
        d_west.txtDefId = td_id_west;
        store_txt(w, td_id_west, d_west_id, west_desc);

        // now store the objects
        store_objects(w, array![d_south, d_west]);

        // ROOM
        let barn_desc: ByteArray = make_txt(rm::BARN);
        let _txt_id = h_util::str_hash(@barn_desc);
        let place_name: ByteArray = "eli's barn";
        let rmid = h_util::str_hash(@place_name);
        store_txt(w, _txt_id, rmid, barn_desc);

        let barn = Room {
            roomId: rmid,
            roomType: zrk::RoomType::Barn,
            biomeType: zrk::BiomeType::Prarie,
            txtDefId: _txt_id,
            shortTxt: place_name,
            objectIds: array![],
            dirObjIds: array![d_south_id, d_west_id],
            players: array![]
        };
        store_places(w, array![barn]);
    }

    fn forge_gen(w: IWorldDispatcher, playerid: felt252) {
        // WINDOW EAST
        // Petrol - burn
        // matches - burn

        // WINDOW east
        let mut a_open_east = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the window, closes with a creak",
            enabled: true,
            dBit: true,
            revertable: false,
            affectsActionId: st::NONE,
            affectedByActionId: st::NONE
        };

        let a_open_east_id = h_util::action_hash(@a_open_east);
        a_open_east.actionId = a_open_east_id;
        store_actions(w, array![a_open_east]);

        let window_desc: ByteArray = "a window, about chest height";
        let td_id_window = h_util::str_hash(@window_desc);

        let mut window = Object {
            objectId: st::SETME,
            objType: zrk::ObjectType::Window,
            dirType: zrk::DirectionType::East,
            destId: st::NONE,
            matType: zrk::MaterialType::Glass,
            objectActionIds: array![a_open_east_id],
            txtDefId: td_id_window
        };

        let window_dest_txt: ByteArray = "eli's barn";
        let window_dest_id = h_util::str_hash(@window_dest_txt);
        window.destId = window_dest_id;
        let window_id = h_util::obj_hash(@window);
        window.objectId = window_id;
        store_txt(w, td_id_window, window_id, window_desc);
        store_objects(w, array![window]);

        // chain matches to petrol
        let mut a_light_petrol = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Burn,
            dBitTxt: "the petrol bursts into flames",
            enabled: true,
            revertable: false,
            dBit: false,
            affectsActionId: st::NONE,
            affectedByActionId: st::NONE
        };

        let mut a_burn_match = Action {
            actionId: st::SETME,
            actionType: zrk::ActionType::Burn,
            dBitTxt: "the match, burns with a blue flame",
            enabled: true,
            revertable: false,
            dBit: false,
            affectsActionId: st::NONE,
            affectedByActionId: st::NONE
        };

        let a_light_id = h_util::action_hash(@a_light_petrol);
        let a_burn_id = h_util::action_hash(@a_burn_match);

        a_light_petrol.actionId = a_light_id;
        a_burn_match.actionId = a_burn_id;

        store_actions(w, array![a_light_petrol, a_burn_match]);

        let mut petrol_can = Object {
            objectId: st::SETME,
            objType: zrk::ObjectType::Petrol,
            dirType: zrk::DirectionType::None,
            destId: st::NONE,
            matType: zrk::MaterialType::Metal,
            objectActionIds: array![a_light_id],
            txtDefId: st::SETME
        };

        let mut match_box = Object {
            objectId: st::SETME,
            objType: zrk::ObjectType::Matches,
            dirType: zrk::DirectionType::None,
            destId: st::NONE,
            matType: zrk::MaterialType::Wood,
            objectActionIds: array![a_light_id],
            txtDefId: st::SETME
        };

        let match_box_desc: ByteArray = "a wooden match box, trade marked \"Shoggoth\'s Joy\"";
        let td_id_mb = h_util::str_hash(@match_box_desc);
        match_box.txtDefId = td_id_mb;
        let match_box_id = h_util::obj_hash(@match_box);
        match_box.objectId = match_box_id;
        store_txt(w, td_id_mb, match_box_id, match_box_desc);
        store_objects(w, array![match_box]);

        let petrol_can_desc: ByteArray = "a army issue petrol can, trade marked \"Cthonian Petroleum Corp n.23\"";
        let td_id_pc = h_util::str_hash(@petrol_can_desc);
        petrol_can.txtDefId = td_id_pc;
        let petrol_can_id = h_util::obj_hash(@petrol_can);
        petrol_can.objectId = petrol_can_id;
        store_txt(w, td_id_pc, petrol_can_id, petrol_can_desc);
        store_objects(w, array![petrol_can]);

        let forge_desc: ByteArray = make_txt(rm::FORGE);
        let _txt_id = h_util::str_hash(@forge_desc);
        let place_name: ByteArray = "eli's forge";
        let rmid = h_util::str_hash(@place_name);
        store_txt(w, _txt_id, rmid, forge_desc);

        let forge = Room {
            roomId: rmid,
            roomType: zrk::RoomType::Forge,
            biomeType: zrk::BiomeType::Prarie,
            txtDefId: _txt_id,
            shortTxt: place_name,
            objectIds: array![petrol_can_id, match_box_id],
            dirObjIds: array![window_id],
            players: array![]
        };

        store_places(w, array![forge]);
    }

    fn pass_gen(w: IWorldDispatcher, playerid: felt252) {
        // make an open action for the path west
        // and store it on the world
        // probs should be a txt_def
        let mut a_west = Action {
            actionId: st::NONE,
            actionType: zrk::ActionType::Open,
            dBitTxt: "the path winds west, it is open",
            enabled: true,
            revertable: false,
            dBit: true,
            affectsActionId: 0,
            affectedByActionId: 0
        };

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
        let mut p_west = Object {
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

        let mut place = Room {
            roomId: rmid,
            roomType: zrk::RoomType::Pass,
            biomeType: zrk::BiomeType::Mountains,
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

    // nb the Language server really can't cope with multi line string so make sure its just a long
    // long line
    fn make_txt(id: felt252) -> ByteArray {
        if id == rm::PASS {
            "winds through the mountains, the path is treacherous\ntoilet papered trees cover the steep \nvalley sides below you.\nOn closer inspection the TP might \nbe the remains of a cricket team\nor perhaps a lost and very dead KKK picnic group.\nIt's brass monkeys."
        } else if id == rm::PLAIN {
            "reaches seemingly endlessly to the sky in all directions\nand the sky itself feels greasy and cold.\npyramidal rough shapes dot the horizon and land which\nupon closer examination are made from bufalo skulls.\nThe air tastes of grease and bensons.\nhappy happy happy\n"
        } else if id == rm::BARN {
            "is old and smells of old hay and oddly dissolution\nthe floor is dirt and trampled dried horse shit scattered with straw and broken bottles\nthe smell is not unpleasent and reminds you faintly of petrol and old socks"
        } else if id == rm::FORGE {
            "has been shuttered, well the door has been nailed shut and the window locked\nfrom this side. Now that the window is smashed light creeps in from the barn and through the cracks in the walls and roof\nthe hearth is cold and the place smells of petrol and soot"
        } else {
            "nothing,\nempty space,\nyou slowly dissolve to nothingness..."
        }
    }

    fn store_objects(w: IWorldDispatcher, t: Array<Object>) {
        for element in t {
            set!(w, (element));
        }
    }

    fn store_actions(w: IWorldDispatcher, t: Array<Action>) {
        for element in t {
            set!(w, (element));
        }
    }

    fn store_places(w: IWorldDispatcher, t: Array<Room>) {
        for element in t {
            set!(w, (element));
        }
    }
   

    fn store_txt(world: IWorldDispatcher, id: felt252, ownedBy: felt252, val: ByteArray) {
        set!(world, (Txtdef { id: id, owner: ownedBy, text: val },));
    }
}
