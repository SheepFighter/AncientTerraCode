/mob/living/carbon/human/proc/monkeyize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be teared
			continue
		drop_from_slot(W)
	update_clothing()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		//organs[text("[]", t)] = null
		del(organs[text("[]", t)])
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null
	var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey( loc )
	del(animation)

	O.name = "monkey"
	O.dna = dna
	dna = null
	O.dna.uni_identity = "00600200A00E0110148FC01300B009"
	//O.dna.struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4BB8"
	O.dna.struc_enzymes = "[copytext(O.dna.struc_enzymes,1,1+3*13)]BB8"
	O.loc = loc
	O.viruses = viruses
	viruses = list()
	for(var/datum/disease/D in O.viruses)
		D.affected_mob = O

	if (client)
		client.mob = O
	if(mind)
		mind.transfer_to(O)
	O.a_intent = "hurt"
	O << "<B>You are now a monkey.</B>"
	spawn(0)//To prevent the proc from returning null.
		del(src)
	return O

/mob/living/carbon/human/proc/piratize()
	if(monkeyizing)
		return
	space_pirate = 1
	/*for(var/obj/item/W in src)
		if(W==wear_id) //For blarg. Just keep their ID if they transofrm.
			continue
		del(W)*/
	/*wear_suit = new /obj/item/clothing/suit/pirate
	w_uniform = new /obj/item/clothing/under/pirate
	shoes = new /obj/item/clothing/shoes/syndigaloshes
	belt = new /obj/item/weapon/melee/energy/sword/pirate
	gloves = new /obj/item/clothing/gloves/stungloves
	glasses = new /obj/item/clothing/glasses/eyepatch
	r_store = new /obj/item/weapon/plastique
	l_store = new /obj/item/weapon/cloaking_device
	ears = new /obj/item/device/radio/headset/space_pirate
	head = new /obj/item/clothing/head/bandana
	wear_id = new /obj/item/weapon/card/id/gold
	r_hand = new /obj/item/weapon/gun/energy/pulse_rifle/M1911
	l_hand = new /obj/item/weapon/empgrenade
	update_clothing()*/
	del(wear_suit)
	del(w_uniform)
	del(shoes)
	del(belt)
	del(gloves)
	del(glasses)
	del(r_store)
	del(l_store)
	del(ears)
	del(head)
	del(r_hand)
	del(l_hand)
	equip_if_possible(new /obj/item/clothing/suit/pirate(src), slot_wear_suit)
	equip_if_possible(new /obj/item/clothing/under/pirate(src), slot_w_uniform)
	equip_if_possible(new /obj/item/clothing/shoes/syndigaloshes(src), slot_shoes)
	equip_if_possible(new /obj/item/weapon/empgrenade(src), slot_belt)
	equip_if_possible(new /obj/item/clothing/gloves/stungloves(src), slot_gloves)
	equip_if_possible(new /obj/item/clothing/glasses/eyepatch(src), slot_glasses)
	equip_if_possible(new /obj/item/weapon/plastique(src), slot_r_store)
	equip_if_possible(new /obj/item/weapon/cloaking_device(src), slot_l_store)
	equip_if_possible(new /obj/item/device/radio/headset/space_pirate(src), slot_ears)
	if(gender == FEMALE) //If female, give a bandanna. If male, give a pirate hat.
		equip_if_possible(new /obj/item/clothing/head/bandana(src), slot_head)
	else
		equip_if_possible(new /obj/item/clothing/head/pirate(src), slot_head)
	equip_if_possible(new /obj/item/weapon/gun/projectile/gunthroat(src), slot_r_hand)
	equip_if_possible(new /obj/item/weapon/melee/energy/sword/pirate(src), slot_l_hand)

	//TODO: Check if has client. If not, then set it NPC controlled.
	//if(!logged_in)
	if(!client)
		npc = 1

/mob/new_player/AIize()
	spawning = 1
	return ..()

/mob/living/carbon/human/AIize()
	if (monkeyizing)
		return
	for(var/t in organs)
		del(organs[text("[]", t)])
	return ..()

/mob/living/carbon/AIize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_slot(W)
	update_clothing()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	return ..()

/mob/proc/AIize()
	if(client)
		client.screen.len = null
	var/mob/living/silicon/ai/O = new (loc, /datum/ai_laws/asimov,,1)//No MMI but safety is in effect.
	O.invisibility = 0
	O.aiRestorePowerRoutine = 0
	O.lastKnownIP = client.address

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.mind = new
		O.mind.current = O
		O.mind.original = O
		O.mind.assigned_role = "AI"
		O.key = key

	if(!(O.mind in ticker.minds))
		ticker.minds += O.mind//Adds them to regular mind list.

	var/obj/loc_landmark
	for(var/obj/landmark/start/sloc in world)
		if (sloc.name != "AI")
			continue
		if (locate(/mob) in sloc.loc)
			continue
		loc_landmark = sloc
	if (!loc_landmark)
		for(var/obj/landmark/tripai in world)
			if (tripai.name == "tripai")
				if(locate(/mob) in tripai.loc)
					continue
				loc_landmark = tripai
	if (!loc_landmark)
		O << "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone."
		for(var/obj/landmark/start/sloc in world)
			if (sloc.name == "AI")
				loc_landmark = sloc

	O.loc = loc_landmark.loc
	for (var/obj/item/device/radio/intercom/comm in O.loc)
		comm.ai += O

	O << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
	O << "<B>To look at other parts of the station, double-click yourself to get a camera menu.</B>"
	O << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
	O << "To use something, simply double-click it."
	O << "Currently right-click functions will not work for the AI (except examine), and will either be replaced with dialogs or won't be usable by the AI."
	if (!(ticker && ticker.mode && (O.mind in ticker.mode.malf_ai)))
		O.show_laws()
		O << "<b>These laws may be changed by other players, or by you being the traitor.</b>"

	O.verbs += /mob/living/silicon/ai/proc/ai_call_shuttle
	O.verbs += /mob/living/silicon/ai/proc/show_laws_verb
	O.verbs += /mob/living/silicon/ai/proc/ai_camera_track
	O.verbs += /mob/living/silicon/ai/proc/ai_alerts
	O.verbs += /mob/living/silicon/ai/proc/ai_camera_list
	O.verbs += /mob/living/silicon/ai/proc/ai_statuschange
	O.verbs += /mob/living/silicon/ai/proc/ai_roster

//	O.verbs += /mob/living/silicon/ai/proc/ai_cancel_call
	O.job = "AI"

	spawn(0)
		ainame(O)
		world << text("<b>[O.real_name] is the AI!</b>")

		spawn(50)
			world << sound('newAI.ogg')

		del(src)

	return O

//human -> robot
/mob/living/carbon/human/proc/Robotize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_slot(W)
	update_clothing()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		del(organs[text("[t]")])
	if(client)
		//client.screen -= main_hud1.contents
		client.screen -= hud_used.contents
		client.screen -= hud_used.adding
		client.screen -= hud_used.mon_blo
		client.screen -= list( oxygen, throw_icon, i_select, m_select, toxin, internals, fire, hands, healths, pullin, blind, flash, rest, sleep, mach )
		client.screen -= list( zone_sel, oxygen, throw_icon, i_select, m_select, toxin, internals, fire, hands, healths, pullin, blind, flash, rest, sleep, mach )
	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( loc )

	// cyborgs produced by Robotize get an automatic power cell
	O.cell = new(O)
	O.cell.maxcharge = 7500
	O.cell.charge = 7500


	O.gender = gender
	O.invisibility = 0
	O.name = "Cyborg"
	O.real_name = "Cyborg"
	O.lastKnownIP = client.address ? client.address : null
	if (mind)
		mind.transfer_to(O)
		if (mind.assigned_role == "Cyborg")
			mind.original = O
		else if (mind.special_role) O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	else
		mind = new /datum/mind(  )
		mind.key = key
		mind.current = O
		mind.original = O
		mind.transfer_to(O)

	if(!(O.mind in ticker.minds))
		ticker.minds += O.mind//Adds them to regular mind list.

	O.loc = loc
	O << "<B>You are playing a Robot. A Robot can interact with most electronic objects in its view point.</B>"
	O << "<B>You must follow the laws that the AI has. You are the AI's assistant to the station basically.</B>"
	O << "To use something, simply double-click it."
	O << {"Use say ":s to speak to fellow cyborgs and the AI through binary."}

	O.job = "Cyborg"

	O.mmi = new /obj/item/device/mmi(O)
	O.mmi.transfer_identity(src)//Does not transfer key/client.

	spawn(0)//To prevent the proc from returning null.
		del(src)
	return O

//human -> alien
/mob/living/carbon/human/proc/Alienize()
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_slot(W)
	update_clothing()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		del(organs[t])

	var/alien_caste = pick("Hunter","Sentinel","Drone")
	var/mob/living/carbon/alien/humanoid/new_xeno
	switch(alien_caste)
		if("Hunter")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter (loc)
		if("Sentinel")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel (loc)
		if("Drone")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone (loc)

	//Honestly not sure why it's giving them DNA.
	/*
	new_xeno.dna = dna
	dna = null
	new_xeno.dna.uni_identity = "00600200A00E0110148FC01300B009"
	new_xeno.dna.struc_enzymes = "0983E840344C39F4B059D5145FC5785DC6406A4BB8"
	*/

	new_xeno.mind_initialize(src, alien_caste)
	new_xeno.key = key

	new_xeno.a_intent = "hurt"
	new_xeno << "<B>You are now an alien.</B>"
	spawn(0)//To prevent the proc from returning null.
		del(src)
	return

/mob/living/carbon/human/proc/Metroidize(adult as num, reproduce as num)
	if (monkeyizing)
		return
	for(var/obj/item/W in src)
		drop_from_slot(W)
	update_clothing()
	monkeyizing = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		del(organs[t])

	if(reproduce)
		var/number = pick(2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,4)
		var/list/babies = list()
		for(var/i=1,i<=number,i++) // reproduce (has a small chance of producing 3 or 4 offspring)
			var/mob/living/carbon/metroid/M = new/mob/living/carbon/metroid(loc)
			M.nutrition = round(nutrition/number)
			step_away(M,src)
			babies += M


		var/mob/living/carbon/metroid/new_metroid = pick(babies)

		new_metroid.mind_initialize(src)
		new_metroid.key = key

		new_metroid.a_intent = "hurt"
		new_metroid << "<B>You are now a baby Metroid.</B>"

	if(adult)
		var/mob/living/carbon/metroid/adult/new_metroid = new /mob/living/carbon/metroid/adult (loc)
		new_metroid.mind_initialize(src)
		new_metroid.key = key

		new_metroid.a_intent = "hurt"
		new_metroid << "<B>You are now an adult Metroid.</B>"

	else
		var/mob/living/carbon/metroid/new_metroid = new /mob/living/carbon/metroid (loc)

		new_metroid.mind_initialize(src)
		new_metroid.key = key

		new_metroid.a_intent = "hurt"
		new_metroid << "<B>You are now a baby Metroid.</B>"
	spawn(0)//To prevent the proc from returning null.
		del(src)
	return