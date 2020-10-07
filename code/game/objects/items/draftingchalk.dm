/obj/item/pen/crayon/chalk
	name = "chalk"
	desc = "A piece of chalk for marking areas of floor, or for drawing."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "dchalk"
	colour = "#FFFFFF"
	attack_verb = list("attacked", "marked", "poked")
	colourName = "white"
	reagents_to_add = null
	utensiltype = "chalk"

/obj/item/pen/crayon/chalk/red
	colour = "#E75344"
	colourName = "red"

/obj/item/pen/crayon/chalk/yellow
	colour = "#E1CB47"
	colourName = "yellow"

/obj/item/pen/crayon/chalk/green
	colour = "#6CD48F"
	colourName = "green"

/obj/item/pen/crayon/chalk/blue
	colour = "#9FC8F7"
	colourName = "blue"

/obj/item/pen/crayon/chalk/purple
	colour = "#a489c2"
	colourName = "purple"

/obj/item/pen/crayon/chalk/Initialize()
	. = ..()
	color = colour
	var/descColourName = " [colourName]"
	desc = "A piece of[descColourName] chalk for marking areas of floor, or for drawing."
	shadeColour = colour

/obj/item/storage/box/fancy/crayons/chalkbox
	name = "box of chalk"
	desc = "A box of chalk for drafting floor plans, or just drawing with."
	icon_state = "chalkbox"
	icon_type = "chalk"
	can_hold = list(
		/obj/item/pen/crayon/chalk
	)

/obj/item/storage/box/fancy/crayons/chalkbox/fill()
	new /obj/item/pen/crayon/chalk/red(src)
	new /obj/item/pen/crayon/chalk(src)
	new /obj/item/pen/crayon/chalk/yellow(src)
	new /obj/item/pen/crayon/chalk/green(src)
	new /obj/item/pen/crayon/chalk/blue(src)
	new /obj/item/pen/crayon/chalk/purple(src)
	update_icon()

/obj/item/storage/box/fancy/crayons/chalkbox/update_icon()
	cut_overlays()
	for(var/obj/item/pen/crayon/chalk/chalk in contents)
		add_overlay("[chalk.colourName]")
