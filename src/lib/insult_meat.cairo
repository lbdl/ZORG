//! handle bad commands and idiocy, basicly take an err code and then
// generate some text output which we can pass back to the caller

mod insulter {
    use the_oruggin_trail::constants::zrk_constants::{ErrCode as ec};

    /// We opine on errors!
    /// 
    /// generates an output string for error handling
    ///  doesnt have any randomness as yet but needs it
    fn opine_on_errors(err: ec, cmd: @Array<ByteArray>) -> ByteArray {
        "foo"
    //   match err {
    //     ZErr::BadFood => { "foo" },
    //     _ => { "bar" },
    //   } 
    }

}