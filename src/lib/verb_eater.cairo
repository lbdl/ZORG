pub mod verb_dispatcher {
    // use the_oruggin_trail::lib::interop_dispatch::interop_dispatcher as interop;
    use the_oruggin_trail::systems::tokeniser::confessor::{Garble};
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::lib::look::lookat;
    use the_oruggin_trail::lib::move::relocate as mv;
    use the_oruggin_trail::lib::act::pullstrings as act;
    use the_oruggin_trail::models::{output::{Output}, zrk_enums::{ActionType, ObjectType}};
    use the_oruggin_trail::constants::zrk_constants::{statusid as st};

    pub fn handleGarble(ref world: IWorldDispatcher, pid: felt252, msg: Garble) {
        println!("HNDL: ---> {:?}", msg.vrb);
        let mut out: ByteArray = "Shoggoth is loveable by default";
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
            ActionType::Move => {
                let nxt_rm_id = mv::get_next_room(world, pid, msg);
                if nxt_rm_id == st::NONE {
                    out =
                        "no. you cannot go that way.\n\"reasons\" mumbles shoggoth into his hat\n she seems to be waving a hand shaped thing"
                } else {
                    mv::enter_room(world, pid, nxt_rm_id);
                    out = lookat::describe_room_short(world, nxt_rm_id);
                }
            },
            _ => { 
                out = act::on(world, pid, msg);
            },
        }
        // we probably need to hand off to another routine here to interpolate
        // some results and create a string for now though
        set!(world, Output { playerId: pid, text_o_vision: out })
    }
}
