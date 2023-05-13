Scriptname blocksteal_mcm extends SKI_ConfigBase  

int[]  _ID
bool[] _SET
int[]  _IDF
float[] _SETF
int[]  _ID2
bool[] _SET2

Perk property bs_perk auto
Formlist property basket_formlist auto
ObjectReference property basket_container auto

int function GetVersion()
	return 1
endFunction

Event OnVersionUpdate(int a_version)
;	if (a_version >= 2 && CurrentVersion < 2)
;	endif
endEvent

Event OnConfigInit()
	ModName = "$BLOCKSTEAL_MODNAME"
	_ID  = new int[10]
	_SET = new bool[10]
	_IDF  = new int[3]
	_SETF = new float[3]
	_ID2 = new int[15]
	_SET2 = new bool[15]

	_SET[0] = true
	_SET[1] = false
;	_SET[2] = false
;	_SET[3] = false
;	_SET[4] = false

	_SETF[0] = 2
	_SETF[1] = 0.3
	
	_SET2[0]  = true	;kFormType_Weapon
	_SET2[1]  = true	;kFormType_Armor
	_SET2[2]  = true	;kFormType_Ammo
	_SET2[3]  = true	;kFormType_Ingredient
	_SET2[4]  = true	;kFormType_Tree
	_SET2[5]  = true	;kFormType_Flora
	_SET2[6]  = true	;kFormType_ScrollItem
	_SET2[7]  = true	;kFormType_SoulGem
	_SET2[8]  = true	;kFormType_Misc
	_SET2[9]  = true	;kFormType_Key
	_SET2[10] = false	;27
	_SET2[11] = true	;kFormType_Potion
	_SET2[12] = true	;kFormType_NPC
	
	ApplySetting()
endEvent

Event OnConfigOpen()
	_SET[2] = false
	_SET[3] = false
	_SET[4] = false
endEvent

Event OnGameReload()
	parent.OnGameReload()
	ApplySetting()
endEvent

Event OnPageReset(String a_Page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	_ID[0] = AddToggleOption("$BLOCKSTEAL_SNEAKING", _SET[0])
	_ID[1] = AddToggleOption("$BLOCKSTEAL_MULTITAP", _SET[1])
	AddEmptyOption()
	_IDF[0] = AddSliderOption("$BLOCKSTEAL_MULTITAP_COUNT", _SETF[0], "$BLOCKSTEAL_MULTITAP_COUNT{0}")
	_IDF[1] = AddSliderOption("$BLOCKSTEAL_MULTITAP_TIME", _SETF[1], "$BLOCKSTEAL_MULTITAP_TIME{1}SEC")
	SetCursorPosition(1)
	_ID[2] = AddToggleOption("$BLOCKSTEAL_BASKET", _SET[2])
	_ID[3] = AddToggleOption("$BLOCKSTEAL_SAVE", _SET[3])
	_ID[4] = AddToggleOption("$BLOCKSTEAL_LOAD", _SET[4])
endEvent

event OnOptionSliderOpen(int option)
	if (option == _IDF[0])
		SetSliderDialogStartValue(_SETF[0])
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(2.0, 4.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == _IDF[1])
		SetSliderDialogStartValue(_SETF[1])
		SetSliderDialogDefaultValue(0.3)
		SetSliderDialogRange(0.1, 1.0)
		SetSliderDialogInterval(0.1)
	endIf
endEvent

event OnOptionSliderAccept(int option, float value)
	if (option == _IDF[0])
		_SETF[0] = value
		SetSliderOptionValue(_IDF[0], _SETF[0], "$BS_MULTITAPCOUNT{0}")
	elseIf (option == _IDF[1])
		_SETF[1] = value
		SetSliderOptionValue(_IDF[1], _SETF[1], "$BS_MULTITAPDELAY{1}SEC")
	endIf
endEvent

bool function toggleSet(bool bbb)
	return !bbb
endFunction

event OnOptionSelect(int a_option)
	int index = _ID.find(a_option)
	if (index > -1)
		if (index == 2)
			bool continue = ShowMessage("$BLOCKSTEAL_OPEN_BASKET_MSG", true, "$BLOCKSTEAL_OK", "$BLOCKSTEAL_CANCEL")
			if (continue)
				blocksteal.CloseJournalMenu()
				basket_container.Activate(Game.GetPlayer())
			endif
		elseif (index == 3)
			bool continue = ShowMessage("$BLOCKSTEAL_SAVEITEMS_MSG", true, "$BLOCKSTEAL_OK", "$BLOCKSTEAL_CANCEL")
			if (continue)
				blocksteal.SaveBasket("blocksteal_basket.tsv")
			endif
		elseif (index == 4)
			bool continue = ShowMessage("$BLOCKSTEAL_LOADITEMS_MSG", true, "$BLOCKSTEAL_OK", "$BLOCKSTEAL_CANCEL")
			if (continue)
				if (basket_container.GetNumItems() > 0)
					continue = ShowMessage("$BLOCKSTEAL_OVERWRITE_MSG", true, "$BLOCKSTEAL_OK", "$BLOCKSTEAL_CANCEL")
					if (!continue)
						return
					endif
				endif
				basket_container.RemoveAllItems()
				basket_formlist.revert()
				blocksteal.LoadBasket("blocksteal_basket.tsv")
				basket_container.AddItem(basket_formlist)
			endif
		else
			_SET[index] = toggleSet(_SET[index])
			SetToggleOptionValue(a_option, _SET[index])
		endif
	endif
endEvent

event OnOptionHighlight(int a_option)
	int index = _ID.find(a_option)
	if (index == -1)
		return
	endif
	if (index == 0)
		SetInfoText("$BLOCKSTEAL_SNEAKING_MSG")
	elseif (index == 1)
		SetInfoText("$BLOCKSTEAL_MULTITAP_MSG")
	elseif (index == 2)
		SetInfoText("$BLOCKSTEAL_BASKET_MSG")
	elseif (index == 3)
		SetInfoText("$BLOCKSTEAL_SAVE_MSG")
	elseif (index == 4)
		SetInfoText("$BLOCKSTEAL_LOAD_MSG")
	endif
endEvent

Event OnConfigClose()
	ApplySetting()
EndEvent

Function ApplySetting()
	blocksteal.PutSettings(_SET, _SETF, _SET2)
	Game.GetPlayer().RemovePerk(bs_perk)
	if (_SET[0] || _SET[1])
		Game.GetPlayer().AddPerk(bs_perk)
	endif
endFunction
