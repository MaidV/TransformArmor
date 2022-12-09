Scriptname TA_MCMConfig extends SKI_ConfigBase

int version = 000010

int spellEnabledOID
int perkEnabledOID
int perkSliderOID

bool spellEnabled = true
bool perkEnabled = false
float Property containerProbability Auto

Spell Property TA_TransformArmorSpell Auto
Perk Property TA_ActivateContainerPerk Auto

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
    Debug.Notification("Transform Armor " + GetStrVersion() + " loading, do not open MCM.")
    ModName = "Transform Armor"
    ToggleSpell(TA_TransformArmorSpell)
    Debug.Notification("Transform Armor " + GetStrVersion() + " loaded.")
EndEvent

Event OnVersionUpdate(int vers)
    Debug.Trace("[TA] Updating version")
    OnConfigInit()
    Debug.Trace("[TA] Done updating version")
EndEvent

Event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    SetCursorPosition(0)

    spellEnabled = Game.GetPlayer().HasSpell(TA_TransformArmorSpell)
    spellEnabledOID = AddToggleOption("Spell Enabled", spellEnabled)
    perkEnabledOID = AddToggleOption("Container chance enabled", perkEnabled)
    perkSliderOID = AddSliderOption("Probability?", containerProbability, "{1} percent")
    SetCursorFillMode(LEFT_TO_RIGHT)
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
        ToggleSpell(TA_TransformArmorSpell)
    ElseIf (option == perkEnabledOID)
        perkEnabled = !perkEnabled
        SetToggleOptionValue(perkEnabledOID, perkEnabled)
        TogglePerk(TA_ActivateContainerPerk)
    EndIf
EndEvent
