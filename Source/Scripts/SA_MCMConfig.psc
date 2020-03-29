Scriptname SA_MCMConfig extends SKI_ConfigBase

import AddItemMenuSE

int spellEnabledOID
bool spellEnabled = false

int mapRefreshOID

string[] pureList
string[] slutList
int pureMenuOID
int slutMenuOID
; int wornMenuOID
int mapIndex = 0

Spell Property SA_SluttifyArmorSpell Auto

Function ToggleSpell(Spell tarSpell)
    Actor playerRef = Game.GetPlayer()
    If (spellEnabled)
        playerRef.AddSpell(tarSpell)
    Else
        playerRef.RemoveSpell(tarSpell)
    EndIf
EndFunction

Function RefreshMapList()
    int nForms = JsonUtil.FormListCount("Sluttify Armor/ArmorMap.json", "pure")
    pureList = new string[128]
    slutList = new string[128]
    ; wornList = new string[128]

    int i = 0
    while i < nForms && i < 128
        pureList[i] = JsonUtil.FormListGet("Sluttify Armor/ArmorMap.json", "pure", i).GetName()
        slutList[i] = JsonUtil.FormListGet("Sluttify Armor/ArmorMap.json", "slutty", i).GetName()
        i += 1
    EndWhile
EndFunction

Event OnPageReset(string page)
    {Called when a new page is selected, including the initial empty page}
    SetCursorFillMode(TOP_TO_BOTTOM)
    SetCursorPosition(0)

    spellEnabled = Game.GetPlayer().HasSpell(SA_SluttifyArmorSpell)
    spellEnabledOID = AddToggleOption("Spell Enabled", spellEnabled)
    mapRefreshOID = AddTextOption("Refresh armor map", None)
    SetCursorFillMode(LEFT_TO_RIGHT)
    pureMenuOID = AddMenuOption("Pure clothes list", None)
    slutMenuOID = AddMenuOption("Slutty clothes list", None)
EndEvent

Event OnOptionSelect(int option)
    If (option == spellEnabledOID)
        spellEnabled = !spellEnabled
        SetToggleOptionValue(spellEnabledOID, spellEnabled)
        ToggleSpell(SA_SluttifyArmorSpell)
    ElseIf (option == mapRefreshOID)
        RefreshMapList()
        SetMenuOptionValue(pureMenuOID, pureList[mapIndex])
        SetMenuOptionValue(slutMenuOID, slutList[mapIndex])
    EndIf
EndEvent

Event OnOptionMenuOpen(int option)
    If (option == pureMenuOID)
        SetMenuDialogOptions(pureList)
        SetMenuDialogStartIndex(mapIndex)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndEvent

event OnOptionMenuAccept(int option, int index)
    if (option == pureMenuOID || option == slutMenuOID)
        mapIndex = index
        SetMenuOptionValue(pureMenuOID, pureList[mapIndex])
        SetMenuOptionValue(slutMenuOID, slutList[mapIndex])
    endIf
endEvent
