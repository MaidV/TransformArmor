Scriptname SA_outfit

int Function getSlot(int outfitGroup, int slot) global
    return JIntMap.getObj(outfitGroup, slot)
EndFunction

Function addToSlot(int outfitGroup, int slot, Form inputForm) global
    int slotList = JIntMap.getObj(outfitGroup, slot)
    If !slotList
        slotList = JArray.object()
    EndIf
    JArray.addForm(slotList, inputForm)
    JIntMap.setObj(outfitGroup, slot, slotList)
    debug.trace("Added " + inputForm.getName() + " to slotList " + slot)
EndFunction

Form[] Function constructRandomOutfit(int outfitGroup) global
    int nForms = JMap.count(outfitGroup)
    Form[] newOutfit = Utility.CreateFormArray(nForms)

    int slot = JIntMap.nextKey(outfitGroup, -1, -1)
    int formIdx = 0
    while slot != -1
        int slotList = getSlot(outfitGroup, slot)
        int slotListLen = JArray.count(slotList)
        if slotListLen
            int itemIdx = Utility.randomInt(0, JArray.count(slotList))
            newOutfit[formIdx] = JArray.getForm(slotList, itemIdx)
            formIdx += 1
        endif
        slot = JIntMap.nextKey(outfitGroup, slot, -1)
    endwhile

    return newOutfit
EndFunction
