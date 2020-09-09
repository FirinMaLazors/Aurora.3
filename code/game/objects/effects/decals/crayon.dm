/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A strange collection of symbols drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/type = "rune")
	. = ..()

	name = type
	desc = "A [type] drawn in crayon."

	switch(type)
		if("rune")
			type = "rune[rand(1,6)]"
			desc = "A strange collection of symbols drawn in crayon."
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

	var/icon/mainOverlay = SSicon_cache.crayon_cache[type]
	if (!mainOverlay)
		mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
		mainOverlay.Blend(main,ICON_ADD)
		SSicon_cache.crayon_cache[type] = mainOverlay

	var/icon/shadeOverlay = SSicon_cache.crayon_cache["[type]_s"]
	if (!shadeOverlay)
		shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)
		shadeOverlay.Blend(shade,ICON_ADD)
		SSicon_cache.crayon_cache["[type]_s"] = shadeOverlay

	add_overlay(list(mainOverlay, shadeOverlay))

	SSicon_cache.crayon_cache.Cut()

	add_hiddenprint(usr)

/obj/effect/decal/cleanable/chalk
	name = "rune"
	desc = "A strange collection of symbols drawn in chalk."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1
	smooth = SMOOTH_TRUE	

/obj/effect/decal/cleanable/chalk/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/type = "rune")
	. = ..()

	name = type
	desc = "A [type] drawn in chalk."

	switch(type)
		if("rune")
			type = "rune[rand(1,6)]"
			desc = "A strange collection of symbols drawn in chalk."
		if("graffiti")
			type = pick("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa")

	var/icon/mainOverlay = SSicon_cache.crayon_cache[type]
	if (!mainOverlay)
		mainOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]",2.1)
		mainOverlay.Blend(main,ICON_ADD)
		SSicon_cache.crayon_cache[type] = mainOverlay

	var/icon/shadeOverlay = SSicon_cache.crayon_cache["[type]_s"]
	if (!shadeOverlay)
		shadeOverlay = new/icon('icons/effects/crayondecal.dmi',"[type]s",2.1)
		shadeOverlay.Blend(shade,ICON_ADD)
		SSicon_cache.crayon_cache["[type]_s"] = shadeOverlay

	add_overlay(list(mainOverlay, shadeOverlay))

	SSicon_cache.crayon_cache.Cut()
	
	add_hiddenprint(usr)