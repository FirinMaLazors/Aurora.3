/obj/item/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"
	reagents_to_add = list(/datum/reagent/crayon_dust/red = 10)

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"
	reagents_to_add = list(/datum/reagent/crayon_dust/orange = 10)

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"
	reagents_to_add = list(/datum/reagent/crayon_dust/yellow = 10)

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"
	reagents_to_add = list(/datum/reagent/crayon_dust/green = 10)

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"
	reagents_to_add = list(/datum/reagent/crayon_dust/blue = 10)

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"
	reagents_to_add = list(/datum/reagent/crayon_dust/purple = 10)

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	reagents_to_add = list(/datum/reagent/crayon_dust/grey = 15)

/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	switch(alert("Please select your drawing mode.", "Line or freestyle?", "Line", "Freestyle"))
		if("Line")
			linemode = TRUE
		if("Freestyle")
			linemode = FALSE

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	reagents_to_add = list(/datum/reagent/crayon_dust/brown = 20)

/obj/item/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	switch(alert("Please select your drawing mode.", "Line or freestyle?", "Line", "Freestyle"))
		if("Line")
			linemode = TRUE
		if("Freestyle")
			linemode = FALSE

/obj/item/pen/crayon/afterattack(turf/target, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!istype(target,/turf/simulated/) || target.density || target.is_hole)
		return
	var/drawtype
	if(linemode)
		to_chat(user, "You start marking a line on [target].")
		if(!do_after(user, 1 SECONDS, act_target = target))
			return
		drawtype = "line"
		for (var/obj/effect/decal/cleanable/crayon/line/C in target)
			qdel(C)
		to_chat(user, "You mark a line on [target].")
		new /obj/effect/decal/cleanable/crayon/line(target,colour,shadeColour,drawtype,utensiltype)
	else
		var/originaloc = user.loc
		drawtype = input("Choose what you'd like to draw.", "\proper[utensiltype] drawing") in list("graffiti","rune","letter","arrow")
		if(user.loc != originaloc)
			to_chat(user, "<span class='notice'>You moved!</span>")
			return
		var/drawname
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "\proper[utensiltype] drawing") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				drawname = "a letter"
			if("graffiti")
				drawname = "graffiti"
			if("rune")
				drawname = "a rune"
			if("arrow")
				drawtype = input("Choose the arrow.", "\proper[utensiltype] drawing") in list("left", "right", "up", "down")
				drawname = "an arrow"
		if(!drawname)
			return
		to_chat(user, "You start drawing [drawname] on [target].")	
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype,utensiltype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)  // Adds their fingerprints to the floor the drawing is drawn on. edit: since they're kneeled on the floor -Malmalumam
			if(reagents && LAZYLEN(reagents_to_add) && utensiltype == "crayon")
				for(var/datum/reagent/R in reagents_to_add)
					reagents.remove_reagent(R,0.5/LAZYLEN(reagents_to_add)) //using crayons reduces crayon dust in it.
				if(!reagents.has_all_reagents(reagents_to_add))
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/user, var/target_zone)
	if(ishuman(user) && utensiltype == "crayon")
		var/mob/living/carbon/human/H = user
		if(H.check_has_mouth())
			user.visible_message("<span class='notice'>[user] takes a bite of their crayon and swallows it.</span>", "<span class='notice'>You take a bite of your crayon and swallow it.</span>")
			user.adjustNutritionLoss(-1)
			reagents.trans_to_mob(user, 2, CHEM_INGEST)
			if(reagents.total_volume <= 0)
				user.visible_message("<span class='notice'>[user] finished their crayon!</span>", "<span class='warning'>You ate your crayon!</span>")
				qdel(src)
	else
		..(user, target_zone)

/obj/item/pen/crayon/attack_self(var/mob/user)
	if(linemode)
		linemode = FALSE
		to_chat(user, SPAN_SUBTLE("You will now draw freestyle."))
	else
		linemode = TRUE
		to_chat(user, SPAN_SUBTLE("You will now draw straight lines."))
	return

/obj/item/pen/crayon/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_SUBTLE("Use the [utensiltype] on itself to change how you will draw."))