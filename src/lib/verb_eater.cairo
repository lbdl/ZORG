pub mod verb_dispatcher {
    // use the_oruggin_trail::lib::interop_dispatch::interop_dispatcher as interop;
    use the_oruggin_trail::lib::system::{
        WorldSystemsTrait, ISpawnerDispatcher, ISpawnerDispatcherTrait
    };
    use the_oruggin_trail::systems::tokeniser::confessor::{Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::lib::look::lookat;
    use the_oruggin_trail::lib::move::relocate as mv;
    use the_oruggin_trail::lib::act::pullstrings as act;
    use the_oruggin_trail::models::{
        output::{Output}, player::{Player}, room::{Room}, object::{Object}, inventory::{Inventory},
        zrk_enums::{ActionType, ObjectType, object_type_to_str}
    };
    use the_oruggin_trail::constants::zrk_constants::{statusid as st};
    use the_oruggin_trail::lib::hash_utils::hashutils as h_util;

    pub fn handleGarble(ref world: IWorldDispatcher, pid: felt252, msg: Garble) {
        println!("HNDL: ---> {:?}", msg.vrb);
        let mut out: ByteArray =
            "Shoggoth is loveable by default, but it understands not your commands";
        let mut player: Player = get!(world, pid, (Player));
        match msg.vrb {
            ActionType::Look => {
                // Pass payer id into look handle
                // let output: ByteArray = "Shoggoth stares into the void<\n>the void is staring
                // back<\n>shoggoth is a good boy";
                let output: ByteArray = lookat::stuff(ref world, msg, pid);
                out = output;
            },
            ActionType::Fight => {
                println!("starting a FIGHT. like a MAN");
                // i_out = interop::kick_off(@world);
                let stub: ByteArray = "Shoggoth is a good boy, he will fight you";
                // out = i_out;
                out = stub;
            },
            ActionType::Spawn => {
                let spawner: ISpawnerDispatcher = world.spawner_dispatcher();
                // let mut player: Player = get!(world, pid, (Player));
                if player.location == 0 {
                    spawner.setup();
                    let spawn_rm_name: ByteArray = "walking eagle pass";
                    let spawn_id = h_util::str_hash(@spawn_rm_name);
                    spawner.spawn_player(pid, spawn_id);
                    let desc: ByteArray = lookat::describe_room_short(world, spawn_id);
                    out = desc;
                }
            },
            ActionType::Take => {
                println!("take------->");
                let mut desc: ByteArray = "";
                if msg.dobj == ObjectType::None {
                    let item_desc: ByteArray = object_type_to_str(msg.dobj);
                    desc = "hmmm, there isnt one of those here to take. are you mad fam?";
                } else {
                    let mut rm: Room = get!(world, player.location.clone(), (Room));
                    let mut obj_ids: Array<felt252> = rm.objectIds.clone();
                    let mut new_obj_ids: Array<felt252> = array![];
                    let mut inv: Inventory = get!(world, player.inventory.clone(), (Inventory));
                    let mut found: bool = false;
                    for ele in obj_ids {
                        let obj: Object = get!(world, ele, (Object));
                        if obj.objType == msg.dobj {
                            found = true;
                            inv.items.append(obj.objectId);
                            let item_desc: ByteArray = object_type_to_str(obj.objType);
                            desc =
                                format!(
                                    "you put the {} in your trusty adventurors plastic bag",
                                    item_desc
                                );
                        } else {
                            new_obj_ids.append(ele);
                        }
                    };

                    rm.objectIds = new_obj_ids;
                    set!(world, (rm, inv));
                }
                out = desc;
            },
            ActionType::Help => {
                let txt: ByteArray =
                    "there is little time\nwaste not time on \"I do thing\"\njust type \"do thing\"\ngo north, take ball, look around, fight the power, go to the north, sniff all the glue etc\nthere is no time...\nno time";
                out = txt;
            },
            ActionType::Move => {
                let nxt_rm_id = mv::get_next_room(world, pid, msg);
                if nxt_rm_id == st::NONE {
                    out =
                        "no. you cannot go that way.\n\"reasons\" mumbles shoggoth into his hat\n she seems to be waving a hand shaped thing"
                } else {
                    mv::enter_room(world, pid, nxt_rm_id);
                    let desc: ByteArray = lookat::describe_room_short(world, nxt_rm_id);
                    out = desc;
                }
            },
            _ => { out = act::on(world, pid, msg); },
        }
        // we probably need to hand off to another routine here to interpolate
        // some results and create a string for now though
        set!(world, Output { playerId: pid, text_o_vision: out })
    }
}
