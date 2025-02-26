//Procedures in this file: Brain-stem reattachment surgery.
//////////////////////////////////////////////////////////////////////
//						BRAINSTEM SURGERY							//
//////////////////////////////////////////////////////////////////////

/decl/surgery_step/brainstem
	priority = 2
	req_open = 1
	can_infect = 1

/decl/surgery_step/brainstem/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT) || !(affected.open >= 3))
		return 0
	if(coverage_check(user, target, affected, tool))
		return 0
	return target_zone == BP_HEAD

/////////////////////////////
// Blood Vessel Mending
/////////////////////////////

/decl/surgery_step/brainstem/mend_vessels
	priority = 1
	allowed_tools = list(
		/obj/item/weapon/surgical/FixOVein = 100,
		/obj/item/stack/cable_coil = 40,
		/obj/item/device/assembly/mousetrap = 5)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/brainstem/mend_vessels/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 0

/decl/surgery_step/brainstem/mend_vessels/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to mend the blood vessels on [target]'s brainstem with \the [tool].", \
	"You start to mend the blood vessels on [target]'s brainstem with \the [tool].")
	..()

/decl/surgery_step/brainstem/mend_vessels/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has mended the blood vessels on [target]'s brainstem with \the [tool].</span>" , \
	"<span class='notice'> You have mended the blood vessels on [target]'s brainstem with \the [tool].</span>",)
	target.op_stage.brainstem = 1

/decl/surgery_step/brainstem/mend_vessels/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, tearing at [target]'s brainstem with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, tearing at [target]'s brainstem with \the [tool]!</span>" )
	affected.createwound(PIERCE, 10)
	target.AdjustParalysis(10)

/////////////////////////////
// Bone Drilling
/////////////////////////////

/decl/surgery_step/brainstem/drill_vertebrae
	priority = 3 //Do this instead of expanding the skull cavity
	allowed_tools = list(
		/obj/item/weapon/surgical/surgicaldrill = 100,
		/obj/item/weapon/melee/changeling/arm_blade = 15,
		/obj/item/weapon/pickaxe = 5
	)

	allowed_procs = list(TOOL_SCREWDRIVER = 75)

	min_duration = 200 //Very. Very. Carefully.
	max_duration = 300

/decl/surgery_step/brainstem/drill_vertebrae/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 1

/decl/surgery_step/brainstem/drill_vertebrae/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to drill around [target]'s brainstem with \the [tool].", \
	"You start to drill around [target]'s brainstem with \the [tool].")
	..()

/decl/surgery_step/brainstem/drill_vertebrae/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has drilled around [target]'s brainstem with \the [tool].</span>" , \
	"<span class='notice'> You have drilled around [target]'s brainstem with \the [tool].</span>",)
	target.AdjustParalysis(10) //We're getting Invasive here. This only ticks down when the person is alive, so it's a good side-effect for this step. Rattling the braincase with a drill is not optimal.
	target.op_stage.brainstem = 2
	affected.fracture() //Does not apply damage, simply breaks it if it wasn't already. Doesn't stop a defib on its own.

/decl/surgery_step/brainstem/drill_vertebrae/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, shredding [target]'s brainstem with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, shredding [target]'s brainstem with \the [tool]!</span>" )
	affected.createwound(PIERCE, 10)
	target.AdjustParalysis(15)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(5,10))

/////////////////////////////
// Bone Cleaning
/////////////////////////////

/decl/surgery_step/brainstem/clean_chips
	priority = 3 //Do this instead of picking around for implants.
	allowed_tools = list(
		/obj/item/weapon/surgical/hemostat = 100,
		/obj/item/weapon/melee/changeling/claw = 40) //Surprisingly, claws are kind of okay at picking things out.

	allowed_procs = list(TOOL_WIRECUTTER = 60)

	min_duration = 90
	max_duration = 120

/decl/surgery_step/brainstem/clean_chips/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 2

/decl/surgery_step/brainstem/clean_chips/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to pick around [target]'s brainstem for bone chips with \the [tool].", \
	"You start to pick around [target]'s brainstem for bone chips with \the [tool].")
	..()

/decl/surgery_step/brainstem/clean_chips/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cleaned around [target]'s brainstem with \the [tool].</span>" , \
	"<span class='notice'> You have cleaned around [target]'s brainstem with \the [tool].</span>",)
	target.AdjustParalysis(10) //Still invasive.
	target.op_stage.brainstem = 3

/decl/surgery_step/brainstem/clean_chips/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, gouging [target]'s brainstem with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, gouging [target]'s brainstem with \the [tool]!</span>" )
	affected.createwound(CUT, 5)
	target.AdjustParalysis(10)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs) //If there's more than one...
			O.take_damage(rand(1,10))

/////////////////////////////
// Spinal Cord Repair
/////////////////////////////

/decl/surgery_step/brainstem/mend_cord
	priority = 1 //Do this after IB.
	allowed_tools = list(
		/obj/item/weapon/surgical/FixOVein = 100,
		/obj/item/stack/nanopaste = 50,
		/obj/item/stack/cable_coil = 40,
		/obj/item/device/assembly/mousetrap = 5)

	min_duration = 100
	max_duration = 200

/decl/surgery_step/brainstem/mend_cord/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 3

/decl/surgery_step/brainstem/mend_cord/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to fuse [target]'s spinal cord with \the [tool].", \
	"You start to fuse [target]'s spinal cord with \the [tool].")
	..()

/decl/surgery_step/brainstem/mend_cord/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has fused [target]'s spinal cord with \the [tool].</span>" , \
	"<span class='notice'> You have fused [target]'s spinal cord with \the [tool].</span>",)
	target.op_stage.brainstem = 4
	target.AdjustParalysis(5)
	target.add_modifier(/datum/modifier/franken_sickness, 20 MINUTES)

/decl/surgery_step/brainstem/mend_cord/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, tearing at [target]'s spinal cord with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, tearing at [target]'s spinal cord with \the [tool]!</span>" )
	affected.createwound(PIERCE, 5)
	target.AdjustParalysis(20)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(5,15)) //Down to the wire. Or rather, the cord.

/////////////////////////////
// Vertebrae repair
/////////////////////////////

/decl/surgery_step/brainstem/mend_vertebrae
	priority = 3 //Do this instead of fixing bones.
	allowed_tools = list(
		/obj/item/weapon/surgical/bonegel = 100,
		/obj/item/stack/nanopaste = 50,
		/obj/item/weapon/tape_roll = 5)

	min_duration = 100
	max_duration = 160

/decl/surgery_step/brainstem/mend_vertebrae/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 4

/decl/surgery_step/brainstem/mend_vertebrae/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to mend [target]'s opened vertebrae with \the [tool].", \
	"You start to mend [target]'s opened vertebrae with \the [tool].")
	..()

/decl/surgery_step/brainstem/mend_vertebrae/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has mended [target]'s vertebrae with \the [tool].</span>" , \
	"<span class='notice'> You have mended [target]'s vertebrae with \the [tool].</span>",)
	target.can_defib = 1
	target.op_stage.brainstem = 5

/decl/surgery_step/brainstem/mend_vertebrae/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, tearing at [target]'s spinal cord with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, tearing at [target]'s spinal cord with \the [tool]!</span>" )
	affected.createwound(PIERCE, 5)
	target.AdjustParalysis(15)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(1,10))

/////////////////////////////
// Realign tissues
/////////////////////////////

/decl/surgery_step/brainstem/realign_tissue
	priority = 3 //Do this instead of searching for objects in the skull.
	allowed_tools = list(
		/obj/item/weapon/surgical/hemostat = 100,
		/obj/item/weapon/melee/changeling/claw = 20) //Claws. Good for digging, not so much for moving.

	allowed_procs = list(TOOL_WIRECUTTER = 60)

	min_duration = 90
	max_duration = 120

/decl/surgery_step/brainstem/realign_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 5

/decl/surgery_step/brainstem/realign_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to realign the tissues in [target]'s skull with \the [tool].", \
	"You start to realign the tissues in [target]'s skull with \the [tool].")
	..()

/decl/surgery_step/brainstem/realign_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has realigned the tissues in [target]'s skull back into place with \the [tool].</span>" , \
	"<span class='notice'> You have realigned the tissues in [target]'s skull back into place with \the [tool].</span>",)
	target.AdjustParalysis(5) //I n v a s i v e
	target.op_stage.brainstem = 0 //The cycle begins anew.

/decl/surgery_step/brainstem/realign_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, gouging [target]'s brainstem with \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, gouging [target]'s brainstem with \the [tool]!</span>" )
	affected.createwound(CUT, 5)
	target.AdjustParalysis(30)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(1,10))
