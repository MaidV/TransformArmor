Scriptname SA_MCMConfig extends SKI_ConfigBase

int version = 000003

string[] pureList
string[] slutList

int spellEnabledOID
int perkEnabledOID
int mapRefreshOID
int pureMenuOID
int slutMenuOID

bool spellEnabled = true
bool perkEnabled = false
int mapIndex = 0

Spell Property SA_SluttifyArmorSpell Auto
Perk Property SA_ActivateContainerPerk Auto

Function ToggleSpell(Spell tarSpell)
    Actor playerRef = Game.GetPlayer()
    If (spellEnabled)
        playerRef.AddSpell(tarSpell)
    Else
        playerRef.RemoveSpell(tarSpell)
    EndIf
EndFunction

Function TogglePerk(Perk tarPerk)
    Actor playerRef = Game.GetPlayer()
    If (perkEnabled)
        playerRef.AddPerk(tarPerk)
    Else
        playerRef.RemovePerk(tarPerk)
    EndIf
EndFunction

Function RefreshMapList()
    Debug.Trace("[SA] Refreshing armor list")
    string armorJson = "Data/skse/plugins/StorageUtilData/Sluttify Armor/ArmorMapJC.json"
    pureList = new string[128]
    slutList = new string[128]

    JDB.solveObjSetter(".SA_ArmorMap", JValue.readFromFile(armorJson), true)

    int map = JDB.solveObj(".SA_ArmorMap")
    Form pureForm = JFormMap.nextKey(map)
    int i = 0
    While pureForm != None
        Form slutForm = JFormDB.getForm(pureForm, ".SA_ArmorMap.slutForm")

        If i < 128
            pureList[i] = pureForm.GetName()
            slutList[i] = slutForm.GetName()
        EndIf

        i += 1
        pureForm = JFormMap.nextKey(map, pureForm)
    EndWhile
    Debug.Trace("[SA] Refreshing armor list complete")
EndFunction

int Function GetVersion()
    return version
EndFunction

string Function GetStrVersion()
    int versint = GetVersion()
    int major = versint / (100 * 100)
    int minor = (versint / 100) % 100
    int patch = versint % 100
    return (major as string) + "." + (minor as string) + "." + (patch as string)
EndFunction

Event OnConfigInit()
    Debug.Notification("Sluttify Armor " + GetStrVersion() + " loading, do not open MCM.")
    RefreshMapList()
    ToggleSpell(SA_SluttifyArmorSpell)
    Debug.Notification("Sluttify Armor " + GetStrVersion() + " loaded.")
EndEvent

Event OnVersionUpdate(int vers)
    Debug.Trace("[SA] Updating version")
    OnConfigInit()
    Debug.Trace("[SA] Done updating version")
EndEvent

Event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    SetCursorPosition(0)

    spellEnabled = Game.GetPlayer().HasSpell(SA_SluttifyArmorSpell)
    spellEnabledOID = AddToggleOption("Spell Enabled", spellEnabled)
    perkEnabledOID = AddToggleOption("Perk Enabled", perkEnabled)
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
    ElseIf (option == perkEnabledOID)
        perkEnabled = !perkEnabled
        SetToggleOptionValue(perkEnabledOID, perkEnabled)
        TogglePerk(SA_ActivateContainerPerk)
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
