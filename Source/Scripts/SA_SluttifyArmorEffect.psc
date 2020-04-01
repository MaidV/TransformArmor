Scriptname SA_SluttifyArmorEffect extends ActiveMagicEffect
{Converts armor to sluttified version}

Event OnEffectStart(Actor Target, Actor Caster)
    SA_Library.SluttifyEquipped(Target, Caster, true)
EndEvent
