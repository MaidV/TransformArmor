Scriptname TA_TransformArmorEffect extends ActiveMagicEffect

Event OnEffectStart(Actor Target, Actor Caster)
    TA_Library.TransformEquipped(Target, Caster, true)
EndEvent
