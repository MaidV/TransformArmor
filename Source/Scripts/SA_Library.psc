Scriptname SA_Library

Function SluttifyEquipped(Actor Target, Actor Caster, bool voluntary = true) global
    Form pureForm = Target.GetWornForm(4)
    If pureForm == None
        If voluntary
            Debug.Notification("Can't sluttify armor if you're naked!")
        EndIf
        return
    EndIf

    int armorMap = JDB.solveObj(".SA.ArmorMap")
    int outfitGroup = JFormMap.getObj(armorMap, pureForm)

    Int slotMask = 4
    Float health = WornObject.GetItemHealthPercent(Target, 0, slotMask)
    Enchantment sourceEnchant = WornObject.GetEnchantment(Target, 0, slotMask)
    Float sourceMaxCharge = WornObject.GetItemMaxCharge(Target, 0, slotMask)

    Debug.Trace("[SA] Reading in outfit for " + pureForm.GetName())
    Form[] newOutfit = SA_Outfit.constructRandomOutfit(outfitGroup)
    if newOutfit.length == 0
        if voluntary
            Debug.Notification("Unable to find slut variant of " + pureForm.GetName() + ".")
        endif
        return
    endif
    Debug.trace("[SA] Found slut armor")
    Target.RemoveItem(pureForm, 1, true)
    Debug.trace("[SA] Removed item: " + pureForm.GetName())

    int i = 0
    while i < newOutfit.Length
        Target.EquipItem(newOutfit[i], false, true)
        Debug.trace("[SA] Equipped armor: " + newOutfit[i].GetName())
        i += 1
    endwhile

    ; ; Crashes randomly if you don't wait a bit to temper the armor. Probably conflicting with mods that
    ; ; modify incoming armor (MWA, specifically)
    ; Utility.Wait(0.5)
    ; If health != 1.0
    ;     WornObject.SetItemHealthPercent(Target, 0, slotMask, health)
    ;     Debug.trace("[SA] Tempered armor: " + slutForm.GetName() + " to " + (health as string))
    ; EndIf
    ; If sourceEnchant != None
    ;     WornObject.SetEnchantment(Target, 0, slotMask, sourceEnchant, sourceMaxCharge)
    ;     Debug.trace("[SA] Enchanted armor: " + slutForm.GetName())
    ; EndIf
    Utility.Wait(0.5)
    Target.QueueNiNodeUpdate()

    Debug.Notification(pureForm.GetName() + " has been Sluttified!")
EndFunction
