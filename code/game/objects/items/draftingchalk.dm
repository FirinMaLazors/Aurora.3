/obj/effect/decal/cleanable/draftingchalk
	name = "chalk marking"
	desc = "A line drawn in chalk."
	icon = 'icons/obj/smooth/chalkline-smooth.dmi'
	icon_state = "preview"
	color = "#FFFFFF"
	layer = 2.1
	anchored = TRUE
	smooth = SMOOTH_TRUE

/obj/effect/decal/cleanable/draftingchalk/Initialize(mapload)
	. = ..()
	if (mapload)
		queue_smooth(src)
	else
		smooth_icon(src)
		for (var/obj/effect/decal/cleanable/draftingchalk/C in orange(1, src))
			smooth_icon(C)

/obj/item/pen/drafting
	name = "white chalk"
	desc = "A piece of white chalk for marking areas of floor, or for drawing."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "dchalk"
	color = "#FFFFFF"
	var/colorName = "whitec"
	var/linemode = TRUE
	var/instant = 0

/obj/item/pen/drafting/attack_self(var/mob/user)
	if(linemode)
		linemode = FALSE
		to_chat(user, SPAN_SUBTLE("You will now draw freestyle."))
	else
		linemode = TRUE
		to_chat(user, SPAN_SUBTLE("You will now draw straight lines."))
	return

/obj/item/pen/drafting/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_SUBTLE("Use the chalk on itself to change what you will draw."))

/obj/item/pen/drafting/afterattack(turf/target, mob/user, proximity)
	if(linemode)
		if (!proximity || !istype(target, /turf/simulated) || target.density || target.is_hole)
			return

		to_chat(user, "You start marking a line on [target].")

		if(!do_after(user, 1 SECONDS, act_target = target))
			return

		for (var/obj/effect/decal/cleanable/draftingchalk/C in target)
			qdel(C)

		to_chat(user, "You mark a line on [target].")

		var/obj/effect/decal/cleanable/draftingchalk/C = new(target)
		C.color = color
		target.add_fingerprint(user)
	else	//code copied graciously from crayon.dm
		if(!proximity) 
			return 
		if(istype(target,/turf/simulated/floor))
			var/originaloc = user.loc
			var/drawtype = input("Choose what you'd like to draw.", "Chalk freestyle") in list("graffiti","rune","letter","arrow")
			if (user.loc != originaloc)
				to_chat(user, "<span class='notice'>You moved!</span>")
				return

			switch(drawtype)
				if("letter")
					drawtype = input("Choose the letter.", "Chalk freestyle") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
					to_chat(user, "You start drawing a letter on the [target.name].")
				if("graffiti")
					to_chat(user, "You start drawing graffiti on the [target.name].")
				if("rune")
					to_chat(user, "You start drawing a rune on the [target.name].")
				if("arrow")
					drawtype = input("Choose the arrow.", "Chalk freestyle") in list("left", "right", "up", "down")
					to_chat(user, "You start drawing an arrow on the [target.name].")
			if(instant || do_after(user, 50))
				new /obj/effect/decal/cleanable/chalk(target,color,"#00000000",drawtype)
				playsound(user, pick('sound/bureaucracy/chalk1.ogg','sound/bureaucracy/chalk2.ogg'), 30, FALSE)
				to_chat(user, "You finish drawing.")
				target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
		return

/obj/item/pen/drafting/red
	name = "red chalk"
	desc = "A piece of red chalk for marking areas of floor, or for drawing."
	color = "#E75344"
	colorName = "redc"

/obj/effect/decal/cleanable/draftingchalk/red
	desc = "A line drawn in a red chalk."
	color = "#E75344"

/obj/item/pen/drafting/yellow
	name = "yellow chalk"
	desc = "A piece of yellow chalk for marking areas of floor, or for drawing."
	color = "#E1CB47"
	colorName = "yellowc"

/obj/effect/decal/cleanable/draftingchalk/yellow
	desc = "A line drawn in a yellow chalk."
	color = "#E1CB47"

/obj/item/pen/drafting/green
	name = "green chalk"
	desc = "A piece of yellow chalk for marking areas of floor, or for drawing."
	color = "#6CD48F"
	colorName = "green"

/obj/effect/decal/cleanable/draftingchalk/green
	desc = "A line drawn in a green chalk."
	color = "#6CD48F"

/obj/item/pen/drafting/blue
	name = "blue chalk"
	desc = "A piece of blue chalk for marking areas of floor, or for drawing."
	color = "#9FC8F7"
	colorName = "bluec"

/obj/effect/decal/cleanable/draftingchalk/blue
	desc = "A line drawn in a blue chalk."
	color = "#9FC8F7"

/obj/item/pen/drafting/purple
	name = "purple chalk"
	desc = "A piece of purple chalk for marking areas of floor, or for drawing."
	color = "#a489c2"
	colorName = "purplec"

/obj/effect/decal/cleanable/draftingchalk/purple
	desc = "A line drawn in a purple chalk."
	color = "#a489c2"

/obj/item/storage/box/fancy/crayons/chalkbox
	name = "box of chalk"
	desc = "A box of chalk for drafting floor plans, or just drawing with."
	icon_state = "chalkbox"
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/drafting
	)

/obj/item/storage/box/fancy/crayons/chalkbox/fill()
	new /obj/item/pen/drafting/red(src)
	new /obj/item/pen/drafting(src)
	new /obj/item/pen/drafting/yellow(src)
	new /obj/item/pen/drafting/green(src)
	new /obj/item/pen/drafting/blue(src)
	new /obj/item/pen/drafting/purple(src)
	update_icon()

/obj/item/storage/box/fancy/crayons/chalkbox/update_icon()
	cut_overlays()
	for(var/obj/item/pen/drafting/chalk in contents)
		add_overlay("[chalk.colorName]")
