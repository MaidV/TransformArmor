#!/usr/bin/env python3

import json
import re
import sys
import itertools

with open('AllArmors_dump.json') as f:
    allarmor = json.load(f)

def filter_armors(armor, prefix, slots):
    return prefix.lower() in armor['name'].lower() and \
        set(slots).intersection(set(armor['slots']))

def get_armors(db, prefixes, excludes=None):
    if not excludes:
        excludes = []
    if isinstance(prefixes, str):
        prefixes = [prefixes]
    
    armors = {}
    for mod in ['Skyrim.esm', 'Dawnguard.esm', 'Dragonborn.esm', 'Update.esm', 'Unofficial Skyrim Special Edition Patch.esp']:
        for prefix in prefixes:
            for armor in filter(lambda armor: filter_armors(armor, prefix, [32, 52]), db[mod].values()):
                if armor['name'] not in excludes:
                    armors[mod + '|' + armor['formID']] = armor['name']
    return armors

def get_bikini_gen(db, prefixes, slot):
    if isinstance(prefixes, str):
        prefixes = [prefixes]
    
    armors = {}
    mod = 'The Amazing World of Bikini Armors REMASTERED.esp'
    for prefix in prefixes:
        for armor in filter(lambda armor: filter_armors(armor, prefix, [slot]), db[mod].values()):
            armors[mod + '|' + armor['formID']] = armor['name']
    return armors
        
def get_bikini_top(db, prefix):
    return get_bikini_gen(db, prefix, 32)

def get_bikini_bottom(db, prefix):
    return get_bikini_gen(db, prefix, 52)


tops, armors, bottoms = {}, {}, {}

armors['hide'] = get_armors(allarmor, ['Hide', 'Fur Armor'])
tops['hide'] = get_bikini_top(allarmor, 'Hide')
bottoms['hide'] = get_bikini_bottom(allarmor, 'Hide')


armors['leather'] = get_armors(allarmor, ['Leather',
                                          'Imperial Light',
                                          "Riften Guard's Armor",
                                          "Markarth Guard's Armor",
                                          "Whiterun Guard's Armor",
                                          "Falkreath Guard's Armor",
                                          "Hjaalmarch Guard's Armor",
                                          "Winterhold Guard's Armor",
                                          "Stormcloak Cuirass",
                                          "Studded Armor",
                                          "Studded Imperial Armor",
                                          "Scaled"])
tops['leather'] = get_bikini_top(allarmor, 'Leather')
bottoms['leather'] = get_bikini_bottom(allarmor, 'Leather')

armors['iron'] = get_armors(allarmor, ['Iron', 'Banded Iron'])
tops['iron'] = get_bikini_top(allarmor, 'Iron')
bottoms['iron'] = get_bikini_bottom(allarmor, 'Iron')

armors['steel'] = get_armors(allarmor, ['Steel Armor', 'Imperial Armor'], excludes=["Studded Imperial Armor"])
tops['steel'] = get_bikini_top(allarmor, 'Steel Bikini')
bottoms['steel'] = get_bikini_bottom(allarmor, 'Steel')

armors['dwarven'] = get_armors(allarmor, 'Dwarven')
tops['dwarven'] = get_bikini_top(allarmor, 'Dwarven Bikini')
bottoms['dwarven'] = get_bikini_bottom(allarmor, 'Dwarven Bikini')

armors['ebony'] = get_armors(allarmor, 'Ebony')
tops['ebony'] = get_bikini_top(allarmor, 'Ebony Bikini')
bottoms['ebony'] = get_bikini_bottom(allarmor, 'Ebony')

armors['wolf'] = get_armors(allarmor, 'Wolf')
tops['wolf'] = get_bikini_top(allarmor, 'Wolf')
bottoms['wolf'] = get_bikini_bottom(allarmor, 'Wolf')

armors['orcish'] = get_armors(allarmor, 'Orcish')
tops['orcish'] = get_bikini_top(allarmor, 'Orcish Bikini')
bottoms['orcish'] = get_bikini_bottom(allarmor, 'Orcish')

armors['dragon'] = get_armors(allarmor, 'Dragonplate')
tops['dragon'] = get_bikini_top(allarmor, 'Dragon Bone Bikini Top')
bottoms['dragon'] = get_bikini_bottom(allarmor, 'Dragon Bone')

armors['nord'] = get_armors(allarmor, 'Nordic')
tops['nord'] = get_bikini_top(allarmor, 'Nord Plate Bikini')
bottoms['nord'] = get_bikini_bottom(allarmor, 'Nord Plate')

transforms = {}
for key in armors.keys():
    src_armors = armors[key]
    trg_tops = tops[key]
    trg_bottoms = bottoms[key]

    for form,name in src_armors.items():
        print(form, name)
        transforms[form] = {'32': list(trg_tops.keys()), '52': list(trg_bottoms.keys())}
        

with open('transforms.json', 'w', encoding ='utf8') as json_file:
    json.dump(transforms, json_file, indent=4)
