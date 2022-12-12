#pragma once

#include "json.hpp"
#include <string>
#include <vector>


namespace TransformUtils
{
	struct Article
	{
		std::string name;
		int32_t formID;
		uint32_t slots;
		RE::TESObjectARMO* form;

		Article(){};
		Article(RE::TESObjectARMO* armor);
	};
	typedef std::unordered_map<std::string, std::unordered_map<std::string, Article>> armor_record_t;

	void from_json(const nlohmann::json& j, Article& a);
	void to_json(nlohmann::json& j, const Article& a);

	void LoadArmors();
	void LoadTransforms();
	void DumpArmors();
	armor_record_t& GetLoadedArmors();

	struct Outfit
	{
		std::vector<Article> articles;
	};
	void TryOutfit(RE::Actor* actor, const Outfit& outfit, bool unequip = true);

	bool TransformArmor(RE::Actor* actor, RE::TESObjectARMO* armor);
}
