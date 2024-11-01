
//*
//* Copyright (c) 2024 Tim Storey (itrainspiders) & Archetypal Tech
//*
//* MeaCulpa (mc) 2024 lbdl | itrainspiders
//*

#[cfg(test)]
mod tests {
    use core::clone::Clone;
    use core::array::ArrayTrait;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{deploy_contract, spawn_test_world};

    use the_oruggin_trail::{
        generated::{spawner::{spawner, ISpawnerDispatcher, ISpawnerDispatcherTrait}},
        constants::zrk_constants::roomid as rm,
        models::{
            txtdef::{Txtdef, txtdef}, room::{Room, room},
            action::{Action, action, action_mock_hash as act_phash},
            object::{Object, object, obj_mock_hash as obj_phash},
            zrk_enums::{MaterialType, ActionType, ObjectType, DirectionType, RoomType}
        },
        lib::hash_utils::hashutils as p_hash
    };

    use the_oruggin_trail::tests::test_rig::{
        test_rig,
        test_rig::{Systems, ZERO, OWNER, OTHER}
    };


    #[test]
    #[available_gas(1000000000)]
    fn test_spawn_pass_room_properties() {
        // room should contain 0 objects
        // room should contain 0 players
        // room should have 2 exit
        // room should have 1 textdef
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();

        let room_name: ByteArray = "Walking Eagle Pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(sys.world, pass_id, (Room));

        // assert on the PASS objects properties
        // the name/short description property
        assert_eq!(
            pass.roomType,
            RoomType::Mountains,
            "got {:?}, expected {:?}",
            pass.roomType,
            RoomType::Mountains
        );

        let expected_name: ByteArray = "Walking Eagle Pass";
        let actual = pass.shortTxt.clone();
        assert_eq!(actual, expected_name, "got {:?}, expected {:?}", pass.shortTxt, expected_name);

        //! check the stored text values
        let txtid = pass.txtDefId;
        let txt = get!(sys.world, txtid, (Txtdef));
        let actual_desc = txt.text.clone();
        let expected_desc: ByteArray = "it winds through the mountains, the path is treacherous\ntoilet papered trees cover the steep\nvalley sides below you.\nOn closer inspection the TP might\nbe the remains of a cricket team\nor perhaps a lost and very dead KKK picnic group.\nIt's brass monkeys.";

        // assert description should be as expected
        assert_eq!(actual_desc, expected_desc, "got {:?}, expected {:?}", txt.text, expected_desc);
        
        let actual_owner = txt.owner;
        let expected_owner = pass_id.clone();

        // owner should be the pass id
        assert_eq!(
            actual_owner, expected_owner, "got {:?}, expected {:?}", txt.owner, expected_owner
        );

        // check the objects and players
        // object ids should be empty
        let objects: Array<felt252> = pass.objectIds.clone();
        assert_eq!(objects.len(), 1, "got {:?}, expected {:?}", objects.len(), 1);

        // object should be a boulder
        let object_id = objects.at(0).clone();
        let object: Object = get!(sys.world, object_id, (Object));
        assert_eq!(object.objType, ObjectType::Boulder, "got {:?}, expected {:?}", object.objType, ObjectType::Boulder);

        // boulder should have a disintegrate action
        let actions: Array<felt252> = object.objectActionIds.clone();
        let action_id = actions.at(0).clone();
        let action: Action = get!(sys.world, action_id, (Action));
        assert_eq!(action.actionType, ActionType::Disintegrate, "got {:?}, expected {:?}", action.actionType, ActionType::Disintegrate);

        // player ids should be empty
        let players: Array<felt252> = pass.players.clone();
        assert_eq!(players.len(), 0, "got {:?}, expected {:?}", players.len(), 0);

        // check the rooms exits
        // there should be one
        let exits: Array<felt252> = pass.dirObjIds.clone();
        assert_eq!(exits.len(), 2, "got {:?}, expected {:?}", exits.len(), 1);
    }

    #[test]
    #[available_gas(1000000000)]
    fn test_spawn_pass_exit_properties () {
        // room should have:
        // 2 exits
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();


        let room_name: ByteArray = "Walking Eagle Pass";
        let pass_id: felt252 = p_hash::str_hash(@room_name);

        let pass: Room = get!(sys.world, pass_id, (Room));

        // room should have two exits 
        let exits: Array<felt252> = pass.dirObjIds.clone();
        assert_eq!(exits.len(), 2, "got {:?}, expected {:?}", exits.len(), 2);
        
        // exits
        // WEST
        let exit_w_id = exits.at(0).clone();
        let exit_w: Object = get!(sys.world, exit_w_id, (Object));
        // exit should be a path
        assert_eq!(exit_w.objType, ObjectType::Path, "got {:?}, expected {:?}", exit_w.objType, ObjectType::Path);
        // exit should be west
        assert_eq!(exit_w.dirType, DirectionType::West, "got {:?}, expected {:?}", exit_w.dirType, DirectionType::West);
        // should lead to Bensons Plain
        let dest_w_name = "Bensons Plain";
        let dest_w_id = p_hash::str_hash(@dest_w_name);
        assert_eq!(exit_w.destId, dest_w_id, "got {:?}, expected {:?}", exit_w.destId, dest_w_id);

        // exit west 
        // should be open       
        let actions: Array<felt252> = exit_w.objectActionIds.clone();
        assert_eq!(actions.len(), 1, "got {:?}, expected {:?}", actions.len(), 1);

        let action_id = actions.at(0).clone();
        let action: Action = get!(sys.world, action_id, (Action));

        // action should be:
        // open
        assert_eq!(action.actionType, ActionType::Open, "got {:?}, expected {:?}", action.actionType, ActionType::Open);
        // !revertable
        assert_eq!(action.revertable, false, "got {:?}, expected {:?}", action.revertable, false);
        // dBit
        assert_eq!(action.dBit, true, "got {:?}, expected {:?}", action.dBit, true);
        // enabled
        assert_eq!(action.enabled, true, "got {:?}, expected {:?}", action.enabled, true);
        // affectsActionId 0
        assert_eq!(action.affectsActionId, 0, "got {:?}, expected {:?}", action.affectsActionId, 0);
        // affectedByActionId 0
        assert_eq!(action.affectedByActionId, 0, "got {:?}, expected {:?}", action.affectedByActionId, 0);


        // EAST
        let exit_e_id = exits.at(1).clone();
        let exit_e: Object = get!(sys.world, exit_e_id, (Object));
        // exit should be a path
        assert_eq!(exit_e.objType, ObjectType::Path, "got {:?}, expected {:?}", exit_w.objType, ObjectType::Path);
        // exit should be west
        assert_eq!(exit_e.dirType, DirectionType::East, "got {:?}, expected {:?}", exit_e.dirType, DirectionType::East);
        // should lead to Bensons Plain
        let dest_e_name = "The Alley Off Main Street";
        let dest_e_id = p_hash::str_hash(@dest_e_name);
        assert_eq!(exit_e.destId, dest_e_id, "got {:?}, expected {:?}", exit_e.destId, dest_e_id);


    }
}
