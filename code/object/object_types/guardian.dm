/obj/structure/realmguardian
	name = "Realm Guardian"
	desc = "Protects the masses from evil!"
	icon = 'sprite/mob/mob.dmi'
	icon_state = "shadow"
	var/datum/faction/myFaction = new/datum/faction/colonist
	var/tickRate = 30
	var/datum/ability/myAttack = new/datum/ability/gigabeam
	var/datum/ability/myBoon = new/datum/ability/gigaheal

/obj/structure/realmguardian/New()
	..()
	icon_state = "g_[pick("base","scythe","shield","halberaxe")]"
	addProcessingObject(src)

/obj/structure/realmguardian/doProcess()
	if(tickRate > 0)
		--tickRate
		return
	else
		var/list/nearby = range(16,src)
		for(var/mob/player/M in nearby)
			spawn(1)
				if(!myFaction.isFriendly(M.mobFaction))
					if(!M.checkEffectStack("dead"))
						myAttack.tryCast(src,M)
					else
						new/obj/effect/strike(get_turf(M))
						M.throw_at(src)
						spawn(10)
							sdel(M)
				else
					if(M.playerData.hp.statCurr < M.playerData.hp.statModified)
						myBoon.tryCast(src,M)
		for(var/obj/item/organ/I in nearby)
			spawn(1)
				new/obj/effect/shield(get_turf(I))
				I.throw_at(src)
				spawn(10)
					sdel(I)
		tickRate = initial(tickRate)


///
// GUARDIAN SPELLS
///

/datum/ability/gigabeam
	name = "Giga Beam"
	desc = "Charges a target with entropy, binding them, and then forcefully blowing them backwards."
	abilityRange = 16
	abilityModifier = -1000
	abilityCooldown = 0
	abilityState = "redline"
	abilityIconSelf = /obj/effect/pow
	abilityIconTarget = /obj/effect/target

/datum/ability/gigabeam/Cast(var/mob/player/caster,var/target)
	var/atom/movable/AM = target
	if(AM)
		AM.anchored = 1
		caster.Beam(AM,time=15,icon_state="giga_beam")
		AM.anchored = 0
		AM.throw_at(caster)
	..()

/datum/ability/gigaheal
	name = "Giga Heal"
	desc = "Heals a target"
	abilityRange = 16
	abilityModifier = 1000
	abilityCooldown = 0
	abilityProjectiles = 4
	abilityState = "redcross"
	abilityIconSelf = /obj/effect/pow
	abilityProjectile = /obj/projectile/healingblast
	abilityIconTarget = /obj/effect/heal