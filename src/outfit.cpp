#include <filesystem>
#include <string>
#include <unordered_map>


#include "json.hpp"
#include "outfit.hpp"
#include "utils.hpp"


using nlohmann::json;
using std::string;
using std::unordered_map;
using std::vector;
using namespace RE;

namespace TransformUtils
{
	Article::Article(TESObjectARMO* armor) :
		name(armor->GetFullName()),
		formID(mask_form<int32_t, 6>(armor)),
		slots(static_cast<int32_t>(armor->GetSlotMask())),
		form(armor){};

	armor_record_t armor_map;

	void LoadArmors()
	{
		if (!armor_map.empty())
			return;

		TESDataHandler* data_handler = TESDataHandler::GetSingleton();
		armor_map.clear();
		logger::info("Loading armor from mods");
		bool ignore_skin = true;
		bool playable = true;
		bool ignore_templates = true;
		bool ignore_enchantments = true;
		bool only_enchanted = false;

		std::set<TESObjectARMO*> exclude;
		if (ignore_skin) {
			logger::info("LoadArmors: Filtering out skins");
			BSTArray<TESForm*> races = data_handler->GetFormArray(TESRace::FORMTYPE);

			for (auto& raceform : races) {
				const auto& race = static_cast<TESRace*>(raceform);
				if (race->skin) {
					exclude.insert(race->skin);
				}
			}

			BSTArray<TESForm*> npcs = data_handler->GetFormArray(TESNPC::FORMTYPE);
			for (auto& npcform : npcs) {
				const auto& npc = static_cast<TESNPC*>(npcform);
				if (npc->skin) {
					exclude.insert(npc->skin);
				}
			}
		}

		std::vector<BGSKeyword*> badKeywords = {
			KeywordUtil::GetKeyword("zad_InventoryDevice"),
			KeywordUtil::GetKeyword("zad_Lockable")
		};

		logger::info("LoadArmors: Looping through armors");
		BSTArray<TESForm*>& armors = data_handler->GetFormArray(TESObjectARMO::FORMTYPE);
		for (TESForm* armorform : armors) {
			TESObjectARMO* armor = static_cast<TESObjectARMO*>(armorform);
			logger::debug("Checking armor {}", armor->GetFullName());
			if (ignore_skin && exclude.contains(armor)) {
				logger::debug("Excluding armor due to skin");
				continue;
			}
			if (playable != armor->GetPlayable()) {
				logger::debug("Excluding armor due to not playable");
				continue;
			}
			if (ignore_templates && armor->templateArmor) {
				logger::debug("Excluding armor due to template");
				continue;
			}
			if (ignore_enchantments && armor->formEnchanting) {
				logger::debug("Excluding armor due to enchantment");
				continue;
			}
			if (only_enchanted && !armor->formEnchanting) {
				logger::debug("Excluding armor due to requiring enchantments");
				continue;
			}
			if (KeywordUtil::HasKeywords(armor, badKeywords)) {
				logger::debug("Excluding armor due to having bad keywords");
				continue;
			}
			if (!strlen(armor->GetFullName())) {
				logger::debug("Excluding armor due to not having a name");
				continue;
			}
			logger::debug("Adding new armor to map: {}", armor->GetFullName());

			Article article(armor);
			logger::debug("Created new Article: {}", json(article).dump(-1, ' ', false, json::error_handler_t::ignore));
			armor_map[armor->GetFile()->fileName][mask_form<string, 6>(article.form)] = article;
		}

		logger::info("Loaded all armors into Armor Map");
	}

	void DumpArmors()
	{
		LoadArmors();
		const std::string dump_file("TransformUtils_Armors_Dump.json");
		std::ofstream out(dump_file);
		out << json(armor_map).dump(4, ' ', false, json::error_handler_t::ignore);


		logger::info("Dumped to: {}", (std::filesystem::current_path() / dump_file).string());
	}

	armor_record_t& GetLoadedArmors()
	{
		return armor_map;
	};

	void AddItem(Actor* actor, std::vector<TESForm*>& forms, int32_t count = 1, bool silent = false)
	{
		vector<string> commands;
		for (auto& form : forms)
			commands.push_back("additem " +
							   mask_form<string, 8>(form) + " " +
							   std::to_string(count) + " " +
							   std::to_string(silent));
		run_scripts(actor, commands);
	}

	void from_json(const json& j, Article& a)
	{
		string mod = j.at("mod");
		string formID = j.at("formID");
		logger::info("Article: {} {}", mod, formID);
		a = Article(armor_map[mod][formID]);
	}

	void to_json(json& j, const Article& a)
	{
		std::vector<uint8_t> slots;
		for (int32_t i = 0; i < 32; ++i) {
			if (a.slots >> i & 1)
				slots.push_back((uint8_t)(i + 30));
		}
		j = json{
			{ "name", a.name },
			{ "formID", mask_form<string, 6>(a.form) },
			{ "slots", slots }
		};
	}

	typedef vector<vector<Article>> transform_target_t;
	unordered_map<string, transform_target_t> transform_map;

	void from_json(const json& j, transform_target_t& a);
	void to_json(json& j, const transform_target_t& a);

	void LoadTransforms()
	{
		if (!transform_map.empty())
			return;

		const string basepath = "data/skse/plugins/transform armor";
		for (const auto& entry : std::filesystem::directory_iterator(basepath)) {
			const auto filename = entry.path().string();
			if (!filename.ends_with(".json"))
				continue;
			spdlog::info("Parsing transform file: " + filename);
			try {
				std::ifstream ifs(filename);
				auto parsed = json::parse(ifs);
				for (json::iterator source = parsed.begin(); source != parsed.end(); ++source) {
					transform_target_t tmp;
					from_json(source.value(), tmp);
					for (auto& outfit : transform_map[source.key()])
						tmp.push_back(outfit);

					transform_map[source.key()] = tmp;
				}
			} catch (...) {
				spdlog::warn("Unable to parse " + filename);
			}
		}
		spdlog::info("Loaded transforms");

		for (auto& [src, trgs] : transform_map) {
			spdlog::info(src);
			for (auto& trglist : trgs) {
				string outfit;
				for (auto& trg : trglist)
					outfit += trg.name + " ";
				spdlog::info("    {}", outfit);
			}
		}
	};

	bool TransformArmor(Actor* actor, TESObjectARMO* armor)
	{
		LoadArmors();
		LoadTransforms();

		string file = armor->GetFile()->fileName;
		string form = mask_form<string, 6>(armor);
		string key = file + "|" + form;

		if (!transform_map.count(key)) {
			spdlog::warn("(" + file + ", " + form + ") not in Transform map");
			return false;
		}

		vector<Article> to_equip;
		Outfit outfit;
		if (transform_map.count(key) && transform_map.at(key).size()) {
			const auto& outfits = transform_map.at(key);
			outfit.articles = (outfits[rand() % outfits.size()]);
			TryOutfit(actor, outfit, false);
			return true;
		}
		return false;
	}

	void from_json(const json& j, transform_target_t& a)
	{
		const auto& armor_map = GetLoadedArmors();
		for (json::const_iterator it = j.cbegin(); it != j.cend(); ++it) {
			vector<string> tmp = it.value().get<vector<string>>();
			vector<Article> outfit;

			for (const auto& formpair : tmp) {
				auto [mod, formID] = split_string(formpair);
				if (armor_map.count(mod) && armor_map.at(mod).count(formID))
					outfit.push_back(armor_map.at(mod).at(formID));
			}
			a.push_back(outfit);
		}
	}

	std::unordered_map<string, Outfit> outfit_map;

	void TryOutfit(Actor* actor, const Outfit& outfit, bool unequip)
	{
		ActorEquipManager* equip_manager = ActorEquipManager::GetSingleton();

		if (unequip)
			run_scripts(actor, { "unequipall" });

		std::vector<TESForm*> to_equip;
		to_equip.reserve(outfit.articles.size());
		for (const Article& article : outfit.articles) {
			to_equip.push_back(article.form);
		}
		AddItem(actor, to_equip, 1);

		for (auto& armor : to_equip)
			equip_manager->EquipObject(actor, static_cast<TESObjectARMO*>(armor), nullptr, 1);
	}
}
