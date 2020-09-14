/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "A strange collection of symbols drawn in crayon."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/drawtype = "rune")
	. = ..()

	name = drawtype
	desc = "A [drawtype] drawn in crayon."

	switch(drawtype)
		if("rune")
			drawtype = "rune[rand(1,6)]"
			desc = "A strange collection of symbols drawn in crayon."
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

/obj/effect/decal/cleanable/chalk
	name = "rune"
	desc = "A strange collection of symbols drawn in chalk."
	icon = 'icons/obj/rune.dmi'
	layer = 2.1
	anchored = 1
	smooth = SMOOTH_TRUE	

/obj/effect/decal/cleanable/chalk/Initialize(mapload, main = "#FFFFFF", shade = "#000000", var/drawtype = "rune")
	. = ..()

	name = drawtype
	desc = "A [drawtype] drawn in chalk."

	switch(drawtype)
		if("rune")
			drawtype = "rune[rand(1,6)]"
			desc = "A strange collection of symbols drawn in chalk."
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