Scriptname blocksteal_init_alias extends ReferenceAlias  

Perk property blocksteal_stealperk auto

function OnRaceSwitchComplete()
	if (Game.GetPlayer().HasPerk(blocksteal_stealperk))
		Game.GetPlayer().RemovePerk(blocksteal_stealperk)
	endif
	Game.GetPlayer().AddPerk(blocksteal_stealperk)
endFunction
