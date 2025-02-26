/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys"
	var/radio_desc = ""
	icon_state = "headset"
	item_state = null //To remove the radio's state
	matter = list(MAT_STEEL = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away
	slot_flags = SLOT_EARS
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/ears.dmi')

	var/translate_binary = 0
	var/translate_hive = 0
	var/obj/item/device/encryptionkey/keyslot1 = null
	var/obj/item/device/encryptionkey/keyslot2 = null
	var/ks1type = null
	var/ks2type = null

	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/device/radio/headset/Initialize()
	. = ..()
	internal_channels.Cut()
	if(ks1type)
		keyslot1 = new ks1type(src)
	if(ks2type)
		keyslot2 = new ks2type(src)
	recalculateChannels(1)

/obj/item/device/radio/headset/Destroy()
	qdel(keyslot1)
	qdel(keyslot2)
	keyslot1 = null
	keyslot2 = null
	return ..()

/obj/item/device/radio/headset/list_channels(var/mob/user)
	return list_secure_channels()

/obj/item/device/radio/headset/examine(mob/user)
	. = ..()

	if(radio_desc && Adjacent(user))
		. += "The following channels are available:"
		. += radio_desc

/obj/item/device/radio/headset/handle_message_mode(mob/living/M as mob, list/message_pieces, channel)
	if(channel == "special")
		if(translate_binary)
			var/datum/language/binary = GLOB.all_languages["Robot Talk"]
			binary.broadcast(M, M.strip_prefixes(multilingual_to_message(message_pieces)))
			return RADIO_CONNECTION_NON_SUBSPACE
		if(translate_hive)
			var/datum/language/hivemind = GLOB.all_languages["Hivemind"]
			hivemind.broadcast(M, M.strip_prefixes(multilingual_to_message(message_pieces)))
			return RADIO_CONNECTION_NON_SUBSPACE
		return RADIO_CONNECTION_FAIL

	return ..()

/obj/item/device/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		playsound(loc, 'sound/effects/radio_common.ogg', 20, 1, 1, preference = /datum/client_preference/radio_sounds)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			playsound(loc, 'sound/effects/radio_common.ogg', 20, 1, 1, preference = /datum/client_preference/radio_sounds)
			return ..(freq, level)
	return -1

/obj/item/device/radio/headset/get_worn_icon_state(var/slot_name)
	var/append = ""
	if(icon_override)
		switch(slot_name)
			if(slot_l_ear_str)
				append = "_l"
			if(slot_r_ear_str)
				append = "_r"

	return "[..()][append]"

/obj/item/device/radio/headset/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/device/radio/headset/syndicate
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/syndicate

/obj/item/device/radio/headset/syndicate/alt
	icon_state = "syndie_headset"
	item_state = "headset"
	origin_tech = list(TECH_ILLEGAL = 3)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/syndicate

/obj/item/device/radio/headset/raider
	origin_tech = list(TECH_ILLEGAL = 2)
	syndie = 1
	ks1type = /obj/item/device/encryptionkey/raider

/obj/item/device/radio/headset/raider/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)

/obj/item/device/radio/headset/binary
	origin_tech = list(TECH_ILLEGAL = 3)
	ks1type = /obj/item/device/encryptionkey/binary

/obj/item/device/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	ks2type = /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/headset_sec/alt
	name = "security bowman headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset_alt"
	ks2type = /obj/item/device/encryptionkey/headset_sec

/obj/item/device/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	ks2type = /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset_alt"
	ks2type = /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	ks2type = /obj/item/device/encryptionkey/headset_rob

/obj/item/device/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	ks2type = /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_med/alt
	name = "medical bowman headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset_alt"
	ks2type = /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/headset_sci

/obj/item/device/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "med_headset"
	ks2type = /obj/item/device/encryptionkey/headset_medsci

/obj/item/device/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/headset_com

/obj/item/device/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/headset_com


/obj/item/device/radio/headset/heads/captain
	name = "site manager's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/captain/alt
	name = "site manager's bowman headset"
	desc = "The headset of the boss."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/captain/sfr
	name = "SFR headset"
	desc = "A headset belonging to a Sif Free Radio DJ. SFR, best tunes in the wilderness."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/captain

/obj/item/device/radio/headset/heads/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	ks2type = /obj/item/device/encryptionkey/heads/ai_integrated
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/device/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/heads/rd
	name = "research director's headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/rd

/obj/item/device/radio/headset/heads/rd/alt
	name = "research director's bowman headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/rd

/obj/item/device/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lifes."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/hos/alt
	name = "head of security's bowman headset"
	desc = "The headset of the man who protects your worthless lifes."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons"
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/ce/alt
	name = "chief engineer's bowman headset"
	desc = "The headset of the guy who is in charge of morons"
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/ce

/obj/item/device/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/heads/cmo/alt
	name = "chief medical officer's bowman headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/cmo

/obj/item/device/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be Site Manager."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/hop

/obj/item/device/radio/headset/heads/hop/alt
	name = "head of personnel's bowman headset"
	desc = "The headset of the guy who will one day be Site Manager."
	icon_state = "com_headset_alt"
	ks2type = /obj/item/device/encryptionkey/heads/hop

/obj/item/device/radio/headset/headset_mine
	name = "mining radio headset"
	desc = "Headset used by miners. Has inbuilt short-band radio for when comms are down."
	icon_state = "mine_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves."
	icon_state = "cargo_headset"
	ks2type = /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	desc = "A bowman headset used by the QM and his slaves."
	icon_state = "cargo_headset_alt"
	ks2type = /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping the station full, happy and clean."
	icon_state = "srv_headset"
	ks2type = /obj/item/device/encryptionkey/headset_service

/obj/item/device/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset"
	centComm = 1
//	freerange = 1
	ks2type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/ert/alt
	name = "emergency response team bowman headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset_alt"
//	freerange = 1
	ks2type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/omni		//Only for the admin intercoms
	ks2type = /obj/item/device/encryptionkey/omni

/obj/item/device/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	ks2type = /obj/item/device/encryptionkey/heads/hos

/obj/item/device/radio/headset/mmi_radio
	name = "brain-integrated radio"
	desc = "MMIs and synthetic brains are often equipped with these."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	var/mmiowner = null
	var/radio_enabled = 1

/obj/item/device/radio/headset/mmi_radio/receive_range(freq, level)
	if (!radio_enabled || istype(src.loc.loc, /mob/living/silicon) || istype(src.loc.loc, /obj/item/organ/internal))
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/device/radio/headset/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.set_machine(src)
	if(W.get_tool_quality(TOOL_SCREWDRIVER))
		if(keyslot1 || keyslot2)
			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			if(keyslot1)
				keyslot1.forceMove(get_turf(user))
				keyslot1 = null

			if(keyslot2)
				keyslot2.forceMove(get_turf(user))
				keyslot2 = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption keys in the headset!")
			playsound(src, W.usesound, 50, 1)

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")
		
		return TRUE

	else if(istype(W, /obj/item/device/encryptionkey/))
		if(!keyslot1)
			user.drop_from_inventory(W, src)
			keyslot1 = W

		else if(!keyslot2)
			user.drop_from_inventory(W, src)
			keyslot2 = W
		
		else
			to_chat(user, "The headset can't hold another key!")

		recalculateChannels()
		return TRUE
	
	return ..()


/obj/item/device/radio/headset/recalculateChannels(var/setDescription = 0)
	src.channels = list()
	src.translate_binary = 0
	src.translate_hive = 0
	src.syndie = 0

	if(keyslot1)
		for(var/ch_name in keyslot1.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot1.channels[ch_name]

		if(keyslot1.translate_binary)
			src.translate_binary = 1

		if(keyslot1.translate_hive)
			src.translate_hive = 1

		if(keyslot1.syndie)
			src.syndie = 1

	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			src.translate_binary = 1

		if(keyslot2.translate_hive)
			src.translate_hive = 1

		if(keyslot2.syndie)
			src.syndie = 1

	if(!radio_controller)
		src.name = "broken radio headset"
		return

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	if(setDescription)
		setupRadioDescription()

	return

/obj/item/device/radio/headset/proc/setupRadioDescription()
	var/radio_text = ""
	for(var/i = 1 to channels.len)
		var/channel = channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != channels.len)
			radio_text += ", "

	radio_desc = radio_text
