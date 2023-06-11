/datum/emergency_call/uscm_cbrn
	name = "USCM-CBRN (Squad)"
	mob_max = 7
	probability = 20
//6 Grunts, 1 leader

	var/max_synths = 0
	var/synths = 0



/datum/emergency_call/uscm_cbrn/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME],this is the USS Shadow Line. We have received your distress call and the biological nature of the threat, we are sending our Chemical Biological Incident Response Force to assist. "
	objectives = "Ensure the survival of the [MAIN_SHIP_NAME], eliminate any hostiles, and assist the crew in any way possible."


/datum/emergency_call/uscm_cbrn/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are the CBRN Team Leader of the USS Shadow Line's Chemical Biological Incident Response Force!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SYNTH) && RoleAuthority.roles_whitelist[mob.ckey] & WHITELIST_SYNTHETIC)
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("You are a CBRN Specialist of the USS Shadow Line's Chemical Biological Incident Response Force!"))
		arm_equipment(mob, /datum/equipment_preset/contractor/duty/synth, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/uscm_cbrn/print_backstory(mob/living/carbon/human/M)
	if(ishuman_strict(M))
		to_chat(M, SPAN_BOLD("You were born [pick(60;"in the United States", 20;"on Earth", 20;"on a colony")] to a [pick(75;"average", 15;"poor", 10;"well-established")] family."))
		to_chat(M, SPAN_BOLD("You joined the USCM while you were young, for the glory and honor."))
		to_chat(M, SPAN_BOLD("After basic training you were assigned to the USS Shadow Line's Chemical Biological Incident Response Force"))


	to_chat(M, SPAN_BOLD("You are [pick(80;"unaware", 15;"faintly aware", 5;"knowledgeable")] of the xenomorph threat."))
	to_chat(M, SPAN_BOLD("You are employed by Vanguard's Arrow Incorporated(VAI), as a member of VAI Primary Operations(VAIPO)"))
	to_chat(M, SPAN_BOLD("You are stationed on-board the USS Shadow Line, a part of MSF Hercuilus."))
	to_chat(M, SPAN_BOLD("Under the directive High Command, you have been tasted with providing military aid, and assisting USCMC forces wherever possible."))
	to_chat(M, SPAN_BOLD("The USS Shadow Line is staffed with crew of roughly three hundred marines, and fifty support personnel."))
	to_chat(M, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))
	to_chat(M, SPAN_BOLD('As a side-objective, retrieve any samples of the biological threat that the marines are facing'))



