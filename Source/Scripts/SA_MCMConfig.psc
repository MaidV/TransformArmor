Scriptname SA_MCMConfig extends SKI_ConfigBase

string[] pureList
string[] slutList

int spellEnabledOID
int mapRefreshOID
int pureMenuOID
int slutMenuOID

bool spellEnabled = false
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
    string armorJson = "Data/skse/plugins/StorageUtilData/Sluttify Armor/ArmorMapJC.json"
    pureList = new string[128]
    slutList = new string[128]

    JDB.solveObjSetter(".SluttifyArmor", JValue.readFromFile(armorJson), true)

    int map = JDB.solveObj(".SluttifyArmor")
    Debug.trace("Starting map list")
    Form pureForm = JFormMap.nextKey(map)
    int i = 0
    While pureForm != None
        Form slutForm = JFormDB.getForm(pureForm, ".SluttifyArmor.slutForm")

        If i < 128
            pureList[i] = pureForm.GetName()
            slutList[i] = slutForm.GetName()
        EndIf

        i += 1
        pureForm = JFormMap.nextKey(map, pureForm)
    EndWhile
    
    Debug.trace("Ending map list " + i)
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
    ElseIf (option == slutMenuOID)
        SetMenuDialogOptions(slutList)
        SetMenuDialogStartIndex(mapIndex)
        SetMenuDialogDefaultIndex(0)
    EndIf    
EndEvent

Event OnOptionMenuAccept(int option, int index)
    if (option == pureMenuOID || option == slutMenuOID)
        mapIndex = index
        SetMenuOptionValue(pureMenuOID, pureList[mapIndex])
        SetMenuOptionValue(slutMenuOID, slutList[mapIndex])
    endIf
EndEvent
