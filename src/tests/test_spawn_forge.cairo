#[cfg(test)]
mod tests {
    use core::clone::Clone;
    use core::array::ArrayTrait;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::utils::test::{deploy_contract, spawn_test_world};

    use the_oruggin_trail::{
        systems::{spawner::{spawner, ISpawnerDispatcher, ISpawnerDispatcherTrait}},
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
    #[available_gas(600000000)]
    fn test_spawn_forge_room_properties() {
        // room should contain 0 objects
        // room should contain 0 players
        // room should have 2 exit
        // room should have 1 textdef
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();

        let room_name: ByteArray = "eli's forge";
        let forge_id: felt252 = p_hash::str_hash(@room_name);

        let forge: Room = get!(sys.world, forge_id, (Room));

        // assert on the plain properties
        // type
        assert_eq!(
            forge.roomType,
            RoomType::Forge,
            "got {:?}, expected {:?}",
            forge.roomType,
            RoomType::Forge
        );
        // name
        let expected_name: ByteArray = "eli's forge";
        let actual = forge.shortTxt.clone();
        assert_eq!(actual, 
            expected_name, 
            "got {:?}, expected {:?}", 
            forge.shortTxt, 
            expected_name);

        // description
        let txtid = forge.txtDefId;
        let txt = get!(sys.world, txtid, (Txtdef));
        let actual_desc = txt.text.clone();
        let expected_desc: ByteArray = 
                "the forge has been shuttered, well the door has been nailed shut and the window locked\nfrom this side. Now that it is smashed light ceeps in from the barn and through the cracks in the walls and roof\nthe hearth is cold and the place smells of petrol and soot";

        assert_eq!(actual_desc, 
            expected_desc, 
            "got {:?}, expected {:?}", 
            txt.text, 
            expected_desc);
        
        let actual_owner = txt.owner;
        let expected_owner = forge_id.clone();

        // owner should be the pass id
        assert_eq!(
            actual_owner, 
            expected_owner, 
            "got {:?}, expected {:?}", 
            txt.owner, 
            expected_owner
        );

        // check the rooms exits
        // there should be 1 exits
        let exits: Array<felt252> = forge.dirObjIds.clone();
        assert_eq!(exits.len(), 1, "got {:?}, expected {:?}", exits.len(), 1);

        // check the objects and players
        // object ids should contain 2 item
        let objects: Array<felt252> = forge.objectIds.clone();
        assert_eq!(
            objects.len(), 
            2, "got {:?}, expected {:?}", 
            objects.len(), 
            2);
            
        // check petrol
        let petrol_id = objects.at(0).clone();
        let petrol: Object = get!(sys.world, petrol_id, (Object));
        
        assert_eq!(
            petrol.matType, MaterialType::Metal, 
            "got {:?}, expected {:?}", 
            petrol.matType, MaterialType::Metal);

        assert_eq!(petrol.objType, ObjectType::Can, 
            "got {:?}, expected {:?}", 
            petrol.objType, 
            ObjectType::Can);

        let action_ids = petrol.objectActionIds.clone();
        assert_eq!(action_ids.len(), 1, "got {:?}, expected {:?}", action_ids.len(), 1);
        let petrol_action_id = action_ids.at(0).clone();
        let petrol_action = get!(sys.world, petrol_action_id, (Action));
        assert_eq!(petrol_action.actionType, ActionType::Burn, 
            "got {:?}, expected {:?}", 
            petrol_action.actionType, ActionType::Burn);
        assert_eq!(petrol_action.dBit, false, "got {:?}, expected {:?}", petrol_action.dBit, false);
        assert_eq!(petrol_action.enabled, true, "got {:?}, expected {:?}", petrol_action.enabled, true);
        assert_eq!(petrol_action.revertable, false, "got {:?}, expected {:?}", petrol_action.revertable, false);
        assert_eq!(petrol_action.affectsActionId, 0, "got {:?}, expected {:?}", petrol_action.affectsActionId, 0);
        assert_eq!(petrol_action.affectedByActionId, 0, "got {:?}, expected {:?}", petrol_action.affectedByActionId, 0);

        //check matches
        let matches_id = objects.at(1).clone();
        let matches: Object = get!(sys.world, matches_id, (Object));
        assert_eq!(matches.objType, ObjectType::Chest, 
            "got {:?}, expected {:?}", 
            matches.objType, ObjectType::Match
        );

        assert_eq!(matches.matType, MaterialType::Wood, 
            "got {:?}, expected {:?}", 
            matches.matType, MaterialType::Wood);

        let actions = matches.objectActionIds.clone();
        assert_eq!(actions.len(), 1, "got {:?}, expected {:?}", actions.len(), 1);
        let matches_action_id = actions.at(0).clone();
        let matches_action = get!(sys.world, matches_action_id, (Action));
        assert_eq!(matches_action.actionType, ActionType::Burn, 
            "got {:?}, expected {:?}", 
            matches_action.actionType, 
            ActionType::Burn);
        assert_eq!(matches_action.dBit, false, "got {:?}, expected {:?}", matches_action.dBit, false);
        assert_eq!(matches_action.enabled, true, "got {:?}, expected {:?}", matches_action.enabled, true);
        assert_eq!(matches_action.revertable, false, "got {:?}, expected {:?}", matches_action.revertable, false);
        assert_eq!(matches_action.affectsActionId, 0, "got {:?}, expected {:?}", matches_action.affectsActionId, 0);
        assert_eq!(matches_action.affectedByActionId, 0, "got {:?}, expected {:?}", matches_action.affectedByActionId, 0);

        let players: Array<felt252> = forge.players.clone();
        assert_eq!(players.len(), 0, "got {:?}, expected {:?}", players.len(), 0);
    }

    #[test]
    #[available_gas(600000000)]
    fn test_spawn_forge_exit_properties () {
        // room should have:
        // 1 exit
        // exit E should have:
        // 1 action
        // 1 action should be:
        // open
        // revertable
        // dBit
        // enabled
        // affectsActionId 0
        // affectedByActionId 0
        let sys: Systems = test_rig::setup_world();
        let sut: ISpawnerDispatcher = sys.spawner;
        sut.setup();


        let room_name: ByteArray = "eli's forge";
        let forge_id: felt252 = p_hash::str_hash(@room_name);

        let forge: Room = get!(sys.world, forge_id, (Room));

        // room should have 2 exits 
        let exits: Array<felt252> = forge.dirObjIds.clone();
        assert_eq!(exits.len(), 1, "got {:?}, expected {:?}", exits.len(), 1);
        
        // exit EAST
        let exit_e_id = exits.at(0).clone();
        let exit_e: Object = get!(sys.world, exit_e_id, (Object));
        
        // assert that
        // exit EAST is a WINDOW
        assert_eq!(exit_e.objType, ObjectType::Window, "got {:?}, expected {:?}", exit_e.objType, ObjectType::Window);
        // exit EAST destination should be:
        // eli's forge
        // ids match
        let dest_e_name = "eli's forge";
        let dest_e_id = p_hash::str_hash(@dest_e_name);
        assert_eq!(exit_e.destId, dest_e_id, "got {:?}, expected {:?}", exit_e.destId, dest_e_id);
        // description matches
        let txt_id = exit_e.txtDefId;
        let txt: Txtdef = get!(sys.world, txt_id, (Txtdef));
        let _desc = txt.text.clone();
        let _desc_expected = "a dusty and smashed window, at chest height";
        assert_eq!(_desc, _desc_expected, "got {:?}, expected {:?}", _desc, _desc_expected);
        // exit WEST should be a window
        assert_eq!(exit_e.objType, ObjectType::Window, "got {:?}, expected {:?}", exit_e.objType, ObjectType::Window);
        // exit direction should be:
        // East
        assert_eq!(exit_e.dirType, DirectionType::East, "got {:?}, expected {:?}", exit_e.dirType, DirectionType::East);
        // exit material should be:
        // Glass
        assert_eq!(exit_e.matType, MaterialType::Glass, "got {:?}, expected {:?}", exit_e.matType, MaterialType::Glass);
        // action
        // 1 actions
        let actions: Array<felt252> = exit_e.objectActionIds.clone();
        assert_eq!(actions.len(), 2, "got {:?}, expected {:?}", actions.len(), 1);

       let open_action_id = actions.at(0).clone();
       let open_action: Action = get!(sys.world, open_action_id, (Action));

        // action 1 should be:
        // open
       assert_eq!(open_action.actionType, ActionType::Open, "got {:?}, expected {:?}", open_action.actionType, ActionType::Open);
       // !revertable
       assert_eq!(open_action.revertable, false, "got {:?}, expected {:?}", open_action.revertable, false);
       // dBit
       assert_eq!(open_action.dBit, true, "got {:?}, expected {:?}", open_action.dBit, true);
       // enabled
       assert_eq!(open_action.enabled, true, "got {:?}, expected {:?}", open_action.enabled, true);
       // affectsActionId 
       assert_eq!(open_action.affectsActionId, 0, "got {:?}, expected {:?}", open_action.affectsActionId, 0);

    }
}
