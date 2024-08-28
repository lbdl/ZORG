pub mod err_dispatcher {
    use the_oruggin_trail::constants::zrk_constants::ErrCode as ec;
    use dojo::world::{IWorldDispatcher};
    use the_oruggin_trail::lib::insult_meat::insulter as badmouth;
    use the_oruggin_trail::models::{output::{Output}};

    pub fn error_handle(ref world: IWorldDispatcher, err: ec, pid: felt252) {
        let bogus_cmd: Array<ByteArray> = array![];
        let speech = badmouth::opine_on_errors(err, @bogus_cmd);
        set!(world, Output { playerId: 23, text_o_vision: speech })
    }
}