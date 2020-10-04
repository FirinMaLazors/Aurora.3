/obj/effect/decal/cleanable/crayon
	name = "generic scribble"
	desc = "A generic scribble.  You probably shouldn't see this."
	icon = 'icons/obj/rune.dmi'
	layer = ON_TURF_LAYER
	anchored = TRUE

/obj/effect/decal/cleanable/crayon/line
	name = "crayon marking"
	desc = "A marking drawn in crayon."
	icon = 'icons/obj/smooth/crayonline-smooth.dmi'
	icon_state = "preview"
	smooth = SMOOTH_TRUE

/obj/effect/decal/cleanable/crayon/line/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/drawtype = "line", var/utensiltype = "crayon",var/direction = NORTH,var/istargetwall = FALSE)
	. = ..(mapload, main, shade, drawtype, utensiltype, direction, istargetwall)
	if (mapload)
		queue_smooth(src)
	else
		smooth_icon(src)
		for(var/obj/effect/decal/cleanable/crayon/line/C in orange(1, src))
			smooth_icon(C)

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/drawtype = "rune", var/utensiltype = "crayon", var/direction = NORTH,var/istargetwall = FALSE)
	. = ..()
	if(istargetwall) //if we're drawing on a wall, move the decal one tile towards the drawer's location, then nudge it back 31 pixels, so it can only be seen on one side.  -MalMalumam
		switch(direction)
			if(NORTH)
				y++
				pixel_y -= 31
			if(NORTHEAST)
				pixel_x -= 31
				pixel_y -= 31
				y++
				x++
			if(EAST)
				pixel_x -= 31
				x++
			if(SOUTHEAST)
				pixel_x -= 31
				pixel_y += 31
				x++
				y--
			if(SOUTH)
				pixel_y += 31
				y--
			if(SOUTHWEST)
				pixel_x += 31
				pixel_y += 31
				x--
				y--
			if(WEST)
				pixel_x += 31
				x--
			if(NORTHWEST)
				pixel_x += 31
				pixel_y -= 31
				x--
				y++

	if(drawtype == "line")
		if(utensiltype == "chalk")
			desc = "A marking drawn in chalk."
			icon = 'icons/obj/smooth/chalkline-smooth.dmi'
		add_hiddenprint(usr)
		color = main
		return
	if(utensiltype == "chalk")
		smooth = SMOOTH_TRUE
	name = drawtype
	desc = "A [drawtype] drawn in [utensiltype]."
	switch(drawtype)
		if("rune")
			drawtype = "rune[rand(1,6)]"
			desc = "A strange collection of symbols drawn in [utensiltype]."
		if("graffiti")
			drawtype = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")
	var/icon/mainOverlay = SSicon_cache.crayon_cache[drawtype]
	if (!mainOverlay)
		mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[drawtype]",2.1)
		mainOverlay.Blend(main,ICON_ADD)
		SSicon_cache.crayon_cache[drawtype] = mainOverlay

	var/icon/shadeOverlay = SSicon_cache.crayon_cache["[drawtype]_s"]
	if (!shadeOverlay)
		shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[drawtype]s",2.1)
		shadeOverlay.Blend(shade,ICON_ADD)
		SSicon_cache.crayon_cache["[drawtype]_s"] = shadeOverlay

	add_overlay(list(mainOverlay, shadeOverlay))

	SSicon_cache.crayon_cache.Cut()

	add_hiddenprint(usr)
