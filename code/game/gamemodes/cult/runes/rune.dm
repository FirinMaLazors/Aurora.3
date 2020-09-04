/obj/effect/rune
	desc = "A strange collection of symbols drawn in chalk."
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	unacidable = TRUE
	layer = AO_LAYER
	var/datum/rune/rune

/obj/effect/rune/Initialize(mapload, var/R)
	. = ..()
	if(!R)
		return INITIALIZE_HINT_QDEL
	icon_state = "[rand(1, 6)]"
	filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = "#FF0000")
	rune = new R(src, src)
	SScult.add_rune(rune)

/obj/effect/rune/Destroy()
	SScult.remove_rune(rune)
	QDEL_NULL(rune)
	return ..()

/obj/effect/rune/examine(mob/user, var/distance = -1)
	
	//since runes are drawn with magic blood-infused chalk now, we are overriding the examine proc so they aren't visibly blood-stained, even though they have blood in them
	to_chat(user, "\icon[src] That's an rune.")
	to_chat(user, desc)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses)
			H.glasses.glasses_examine_atom(src, H)

	if(iscultist(user) || isobserver(user))
		to_chat(user, rune.get_cultist_fluff_text())
		to_chat(user, "This rune [rune.can_be_talisman() ? "<span class='cult'><b><i>can</i></b></span>" : "<span class='warning'><b><i>cannot</i></b></span>"] be turned into a talisman.")
	else
		to_chat(user, rune.get_normal_fluff_text())
		
	return distance == -1 || (get_dist(src, user) <= distance)

/obj/effect/rune/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/book/tome) && iscultist(user))
		rune.do_tome_action(user, I)
		return
	else if(istype(I, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [I]!"))
		qdel(src)
		return
	return

/obj/effect/rune/attack_hand(mob/living/user)
	if(!iscultist(user))
		to_chat(user, SPAN_NOTICE("You can't mouth the arcane scratchings without fumbling over them."))
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(user, SPAN_WARNING("You are unable to speak the words of the rune."))
		return
	return rune.activate(user, src)

/obj/effect/rune/cultify()
	return