Scriptname SA_MCMConfig extends SKI_ConfigBase

int version = 000003

string[] pureList
string[] slutList

int spellEnabledOID
int mapRefreshOID
int pureMenuOID
int slutMenuOID

bool spellEnabled = true
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
    Debug.Trace("[SA] Refreshing armor list")
    string armorJson = "Data/skse/plugins/StorageUtilData/Sluttify Armor/ArmorMapJC.json"
    pureList = new string[128]
    slutList = new string[128]
    ; JDB.solveObjSetter(".SluttifyArmor", 0, false)
    JDB.solveObjSetter(".SluttifyArmor", JValue.readFromFile(armorJson), true)

    int map = JDB.solveObj(".SluttifyArmor")
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

int Function Init()
    Debug.Notification("Sluttify Armor " + GetStrVersion() + " loading, do not open MCM.")
    RefreshMapList()
    ToggleSpell(SA_SluttifyArmorSpell)
    Debug.Notification("Sluttify Armor " + GetStrVersion() + " loaded.")
EndFunction

Event OnConfigInit()
    ModName = "Sluttify Armor"
    Debug.Trace("[SA] Initializing")
    Init()
    Debug.Trace("[SA] Initializing complete")
EndEvent

Event OnVersionUpdate(int vers)
    ModName = "Sluttify Armor"
    Debug.Trace("[SA] Updating version")
    Init()
    Debug.Trace("[SA] Done updating version")
EndEvent

Event OnPageReset(string page)
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
