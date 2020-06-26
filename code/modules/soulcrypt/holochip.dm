/obj/item/weapon/holochip
	name = "holochip"
	desc = "A one-use module containing a software package for a soulcrypt."
	icon = 'icons/obj/soulcrypt.dmi'
	icon_state = "holochip_base"

	var/tag_color
	var/used = FALSE
	var/list/contained_modules = list()

/obj/item/weapon/holochip/examine(mob/user)
	. = ..()

/obj/item/weapon/holochip/update_icon()
	overlays.Cut()
	var/image/I = image('icons/obj/soulcrypt.dmi', "holochip_tags")
	I.color = tag_color
	overlays += I

	if(!used)
		overlays += image('icons/obj/soulcrypt.dmi', "holochip_active")
	else
		overlays += image('icons/obj/soulcrypt.dmi', "holochip_inactive")

/obj/item/weapon/holochip/Initialize()
	update_icon()

/obj/item/weapon/holochip/afterattack(atom/A, mob/user)
	if(used)
		to_chat(user, SPAN_WARNING("This holochip is used up."))
		return
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/target = A
		var/obj/item/weapon/implant/soulcrypt/crypt = target.crypt
		if(!crypt)
			to_chat(user, SPAN_WARNING("[target] does not have a soulcrypt."))
			return
		visible_message(SPAN_NOTICE("[user] begins uploading [src] into [target]'s soulcrypt..."))
		if(!do_after(user, 35, target))
			return
		crypt.add_modules(contained_modules)
		used = TRUE
		update_icon()



