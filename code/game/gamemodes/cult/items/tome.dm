/obj/item/book/tome
	name = "arcane tome"
	description_cult = null
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	unique = TRUE
	slot_flags = SLOT_BELT
	var/obj/item/inserted_item  //chalk code graciously stolen from the PDA's pen code   -MalMalmulam
	var/list/contained_item = list(/obj/item/pen/drafting/) 
	var/bloody = ""

/obj/item/pen/drafting/red/cult
	name = "engraved chalk"
	desc = "A piece of chalk for marking areas of floor, or for drawing.  This one has strange symbols engraved on it."
	color = COLOR_HUMAN_BLOOD
	colorName = "redc"	

/obj/item/book/tome/Initialize(mapload, ...)
	. = ..()
	inserted_item =	new /obj/item/pen/drafting/red/cult(src)
	var/list/blooddonors = list()  //the chalk turns the color of a random nearby cultist's blood, if there is one
	for(var/mob/living/carbon/C in range(1, get_turf(src)))
		if(!iscultist(C)) 
			continue
		blooddonors += C
		if(blooddonors.len)
			var/mob/living/carbon/blooddonor = pick(blooddonors)
			inserted_item.color = blooddonor.species.blood_color


obj/item/book/tome/proc/remove_chalk(mob/user)

	if(!istype(user))
		return

	if(use_check_and_message(user))
		return

	if (loc == user && !user.get_active_hand())
		to_chat(user, SPAN_NOTICE("You remove \the [inserted_item] from [src]."))
		user.put_in_hands(inserted_item)
		inserted_item = null

	else
		to_chat(user, SPAN_NOTICE("You remove \the [inserted_item] from [src], dropping it on the ground. Whoops."))
		inserted_item.forceMove(get_turf(src))
		inserted_item = null

/obj/item/book/tome/verb/verb_remove_chalk()
	set category = "Object"
	set name = "Remove chalk"
	set src in usr

	remove_chalk(usr)
	
obj/item/book/tome/attackby(obj/item/C as obj, mob/user as mob)
	if(is_type_in_list(C, contained_item)) //Checks if there is a piece of chalk
		if(inserted_item)
			to_chat(user, SPAN_NOTICE("There is already \a [inserted_item] in \the [src]."))
		else
			user.drop_from_inventory(C,src)
			inserted_item = C
			to_chat(user, SPAN_NOTICE("You put \the [C] into \the [src].>"))
	else
		. = ..()

/obj/item/book/tome/CtrlShiftClick(mob/user)
	remove_chalk(user)

/obj/item/book/tome/AltClick(mob/user)
	remove_chalk(user)

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if(isobserver(M))
		var/mob/abstract/observer/D = M
		D.manifest(user)
		attack_admins(D, user)
		return

	if(!istype(M))
		return

	if(!iscultist(user))
		return ..()

	if(iscultist(M))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	M.take_organ_damage(0, rand(5,20)) //really lucky - 5 hits for a crit
	visible_message(SPAN_WARNING("\The [user] beats \the [M] with \the [src]!"))
	to_chat(M, SPAN_DANGER("You feel searing heat inside!"))
	attack_admins(M, user)

/obj/item/book/tome/proc/attack_admins(var/mob/living/M, var/mob/living/user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had the [name] used on them by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used [name] on [M.name] ([M.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] used [name] on [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))


/obj/item/book/tome/attack_self(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/scribe = user
	if(use_check_and_message(scribe))
		return

	if(iscultist(scribe))
		if(!isturf(scribe.loc))
			to_chat(scribe, SPAN_WARNING("You do not have enough space to write a proper rune."))
			return

		var/turf/T = get_turf(scribe)

		if(T.is_hole || T.is_space())
			to_chat(scribe, SPAN_WARNING("You are unable to write a rune here."))
			return

		switch(alert("What shall you do with the tome?", "Tome of Nar'sie", "Read it", "Scribe a rune", "Cancel"))
			if("Cancel")
				return
			if("Read it")
				if(use_check_and_message(user))
					return
				var/datum/browser/tome_win = new(user, "Arcane Tome", "Nar'Sie's Runes")
				tome_win.set_content(SScult.tome_data)
				tome_win.add_stylesheet("cult", 'html/browser/cult.css')
				tome_win.open()
				return
			if("Scribe a rune")
				// This counts how many runes exist in the game, for some sort of arbitrary rune limit. I trust the old devs had their reasons. - Geeves
				if(SScult.check_rune_limit())
					to_chat(scribe, SPAN_WARNING("The cloth of reality can't take that much of a strain. Remove some runes first!"))
					return

		//only check if they want to scribe a rune, so they can still read if standing on a rune
		if(locate(/obj/effect/rune) in scribe.loc)
			to_chat(scribe, SPAN_WARNING("There is already a rune in this location."))
			return
		
		if(!istype(inserted_item, /obj/item/pen/drafting/red/cult))
			to_chat(scribe, SPAN_WARNING("You need an engraved piece of chalk in the tome to draw with."))
			return

		if(use_check_and_message(scribe))
			return

		var/chosen_rune
		//var/network
		chosen_rune = input("Choose a rune to scribe.") as null|anything in SScult.runes_by_name
		if(!chosen_rune)
			return

		if(use_check_and_message(scribe))
			return

		scribe.visible_message(SPAN_WARNING("[scribe] turns to a page in their book and presses their hand against it, then uses a piece of chalk to draw strange symbols on the ground..."), SPAN_CULT("Turning to the ritual's page, you pierce your hand against the spikes there, imbuing the chalk within with your blood, and start drawing..."))
		
		//piercing your hand on the spikes should add your blood to it.  examine proc keeps it from being obviously blood-stained.  don't know how to handle it being bloodied by normal means... I guess tomes magically suck in all the blood that gets on them? : P the chalk, however, will be bloody.  -MalMalmulam
		
		if(!blood_DNA)
			blood_DNA = list()
		if(!blood_DNA[scribe.dna.unique_enzymes])
			blood_DNA[scribe.dna.unique_enzymes] = scribe.dna.b_type
			bloody = " <font color='red'>bloody</font>"
		
		if(!inserted_item.blood_DNA)  //the chalk's color will become that of the last scribe's blood
			inserted_item.blood_DNA = list()
		if(!inserted_item.blood_DNA[scribe.dna.unique_enzymes])
			inserted_item.blood_DNA[scribe.dna.unique_enzymes] = scribe.dna.b_type	
		inserted_item.color = scribe.species.blood_color
		playsound(scribe, pick('sound/bureaucracy/chalk1.ogg','sound/bureaucracy/chalk2.ogg'), 50, FALSE)

		if(do_after(scribe, 50))
			var/area/A = get_area(scribe)
			if(use_check_and_message(scribe))
				return
			
			//prevents using multiple dialogs to layer runes.
			if(locate(/obj/effect/rune) in get_turf(scribe)) //This is check is done twice. once when choosing to scribe a rune, once here
				to_chat(scribe, SPAN_WARNING("There is already a rune in this location."))
				return

			log_and_message_admins("created \an [chosen_rune] at \the [A.name] - [user.loc.x]-[user.loc.y]-[user.loc.z].") //only message if it's actually made

			var/obj/effect/rune/R = new(get_turf(scribe), SScult.runes_by_name[chosen_rune])
			to_chat(scribe, SPAN_CULT("The chalk's blood spent into the rune, you finish drawing the Geometer's markings with a mental prayer."))
			R.blood_DNA = list()
			R.blood_DNA[scribe.dna.unique_enzymes] = scribe.dna.b_type
			R.color = scribe.species.blood_color
			R.filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = scribe.species.blood_color)
			playsound(scribe, pick('sound/bureaucracy/chalk1.ogg','sound/bureaucracy/chalk2.ogg'), 50, FALSE)
			
	else
		to_chat(user, SPAN_CULT("The book seems full of illegible scribbles and bizarre symbols.   Some of the pages have[bloody] spiked metal studs poking out from them, in the general shape of a hand."))
		if(inserted_item)
			to_chat(user, SPAN_WARNING("A[bloody] piece of chalk lies nestled within a compartment in the back."))

/obj/item/book/tome/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "", var/show_blood = FALSE)

	. = ..()
	
	if(iscultist(user) || isobserver(user))
		to_chat(user, "The unholy scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood.  Contains the details of every ritual his followers could think of. Most of these are useless, though.\ 
		</br>At the end of the listing for each ritual lies a[bloody] hand-shaped set of spikes embedded into the page, with which you imbue your blood into chalk for the ritual's magic.")
		if(inserted_item)
			to_chat(user, SPAN_NOTICE("A[bloody] piece of chalk lies nestled in its compartment."))
	else
		to_chat(user, "An old, dusty tome with frayed edges and a sinister looking cover.")

/obj/item/book/tome/cultify()
	return