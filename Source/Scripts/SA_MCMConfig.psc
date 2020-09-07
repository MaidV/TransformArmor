Scriptname SA_MCMConfig extends SKI_ConfigBase

int version = 000010

string[] pureList
string[] numList

int spellEnabledOID
int perkEnabledOID
int perkSliderOID
int mapRefreshOID

int menuIndexOID
int pureMenuOID

bool spellEnabled = true
bool perkEnabled = false
float Property containerProbability Auto


int mapIndex = 0
int menuIndex = 0

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
    JDB.solveObjSetter(".SA.ArmorMap", JValue.readFromFile(armorJson), true)
    int armorMap = JDB.solveObj(".SA.ArmorMap")

    int nArmors = JFormMap.count(armorMap)
    Debug.Trace("[SA] Found " + nArmors + " source armors in map.")

    ; FIXME: for the love of god is this really necessary
    numList = Utility.CreateStringArray((nArmors - 1) / 128 + 1)
    int i = 0
    while i < numList.Length
        numList[i] = i as string
        i += 1
    endwhile

    int pureListFull = JArray.objectWithSize(nArmors)
    JValue.retain(pureListFull)
    Form pureForm = JFormMap.nextKey(armorMap)
    i = 0
    While pureForm != None
        JArray.setStr(pureListFull, i, pureForm.GetName())
        i += 1
        pureForm = JFormMap.nextKey(armorMap, pureForm)
    EndWhile

    JDB.solveObjSetter(".SA.pureListFull", pureListFull, true)
    JValue.release(pureListFull)

    UpdatePureList()

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
    return major + "." + minor + "." + patch
EndFunction

Event OnConfigInit()
    Debug.Notification("Sluttify Armor " + GetStrVersion() + " loading, do not open MCM.")
    ModName = "Sluttify Armor"
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
    perkEnabledOID = AddToggleOption("Container chance enabled", perkEnabled)
    perkSliderOID = AddSliderOption("Probability?", containerProbability, "{1} percent")
    mapRefreshOID = AddTextOption("Refresh armor map", None)
    menuIndexOID = AddMenuOption("Armor list index", None)

    SetCursorFillMode(LEFT_TO_RIGHT)
    pureMenuOID = AddMenuOption("Pure clothes list", None)
    ; FIXME: populate OIDs and map to slots
    ; slutMenuOID = AddMenuOption("Slutty clothes list", None)
EndEvent

Event OnOptionSliderOpen(int option)
	If (option == perkSliderOID)
		SetSliderDialogStartValue(containerProbability)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
    EndIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
	If (option == perkSliderOID)
		containerProbability = value
		SetSliderOptionValue(perkSliderOID, containerProbability, "{1} percent")
    EndIf
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
        ; FIXME: loop through outfitGroup OIDS and set value
        ; SetMenuOptionValue(slutMenuOID, slutList[mapIndex])
    EndIf
EndEvent

Event OnOptionMenuOpen(int option)
    If (option == pureMenuOID)
        SetMenuDialogOptions(pureList)
        SetMenuDialogStartIndex(mapIndex)
        SetMenuDialogDefaultIndex(0)
    ElseIf (option == menuIndexOID)
        SetMenuDialogOptions(numList)
        SetMenuDialogStartIndex(menuIndex)
        SetMenuDialogDefaultIndex(0)
    Else
        ; must be one of the dynamic menus
        ; FIXME: Need to get OID to point to the right outfitGroup slot
        ; SetMenuDialogOptions(slutList)
        ; SetMenuDialogStartIndex(mapIndex)
        ; SetMenuDialogDefaultIndex(0)
    EndIf
EndEvent

Function UpdatePureList()
    int offset = menuIndex * 128
    int pureListFull = JDB.solveObj(".SA.pureListFull")
    int size = JArray.count(pureListFull) - offset
    if size > 128
        size = 128
    endif
    Debug.Trace("[SA] Updating pure list " + menuIndex + " with size " + size)

    if size >= 0
        int subArray = Jarray.subArray(pureListFull, offset, offset + size)
        pureList = JArray.asStringArray(subArray)
        JValue.zeroLifetime(subArray)
    else
        Debug.Trace("[SA] list index out of range" + (menuIndex as string))
    endif
EndFunction

Event OnOptionMenuAccept(int option, int index)
    if (option == pureMenuOID)
        mapIndex = index
        SetMenuOptionValue(pureMenuOID, pureList[mapIndex])
        ; FIXME: Set outfitgroup
    ElseIf (option == menuIndexOID)
        menuIndex = index
        SetMenuOptionValue(menuIndexOID, menuIndex)
        UpdatePureList()
        SetMenuOptionValue(pureMenuOID, pureList[mapIndex])
        ; FIXME: Set outfitgroup
    endIf
EndEvent
