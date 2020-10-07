/obj/item/paper/talisman
	icon_state = "paper_talisman"
	var/uses = 1
	var/datum/rune/rune
	info = "<center><img src='talisman.png'></center><br/><br/>"

/obj/item/paper/talisman/Initialize()
	. = ..()
	name = "chalked paper"
	color = "FF6D6D"

/obj/item/paper/talisman/Destroy()
	QDEL_NULL(rune)
	return ..()

/obj/item/paper/talisman/examine(mob/user)
	..()
	if(iscultist(user) && rune)
		to_chat(user, "The spell inscription reads: <span class='cult'><b><i>[rune.name]</i></b></span>.")
	else if(!(iscultist(user)) && rune)
		to_chat(user, "The paper has strange drawings in chalk on it.")

/obj/item/paper/talisman/attack_self(mob/living/user)
	if(iscultist(user))
		if(rune)
			user.say("INVOKE!")
			rune.activate(user, src)
			return
		else
			to_chat(user, SPAN_CULT("This talisman has no power."))
	else
		to_chat(user, SPAN_NOTICE("The chalk drawings are strangely sticky, but it doesn't come off."))
		return

/obj/item/paper/talisman/proc/use()
	uses--
	if(uses <= 0)
		qdel(src)
