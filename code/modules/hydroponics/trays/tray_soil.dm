/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	icon_state = "soil"
	density = 0
	use_power = USE_POWER_OFF
	mechanical = 0
	tray_light = 0
	frozen = -1

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/weapon/tank))
		return
	else
		..()

/obj/machinery/portable_atmospherics/hydroponics/soil/Initialize()
	. = ..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/remove_label
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

/obj/machinery/portable_atmospherics/hydroponics/soil/CanPass()
	return 1

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/weapon/shovel))

		if(user.a_intent == I_HURT)
			user.visible_message(SPAN_NOTICE("\The [user] begins filling in \the [src]."))
			if(do_after(user, 3 SECONDS) && !QDELETED(src))
				user.visible_message(SPAN_NOTICE("\The [user] fills in \the [src]."))
				qdel(src)
			return TRUE

		var/turf/T = get_turf(src)
		if(istype(T))
			return T.attackby(O, user)	
	
	. = ..()
	

// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(var/ml, var/datum/seed/newseed)
	. = ..(ml)
	seed = newseed
	dead = 0
	age = 1
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	pixel_y = rand(-5,5)
	check_health()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/remove_dead()
	..()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/harvest()
	..()
	if(!seed) // Repeat harvests are a thing.
		qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/die()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/process()
	if(!seed)
		qdel(src)
		return
	else if(name=="plant")
		name = seed.display_name
	..()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/plant/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.invisibility = initial(plant.invisibility)
	..()
