#include "transform_utils.hpp"

namespace Plugin
{
	using namespace std::literals;

	inline constexpr REL::Version VERSION{
		0,
		1,
		0,
	};

	inline constexpr auto NAME = "TransformUtils";
}

extern "C" DLLEXPORT constinit auto SKSEPlugin_Version = []() {
	SKSE::PluginVersionData v;

	v.PluginVersion(Plugin::VERSION);
	v.PluginName(Plugin::NAME);

	v.UsesAddressLibrary(true);
	v.CompatibleVersions({ SKSE::RUNTIME_LATEST });

	return v;
}();

static inline bool TransformArmor(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESForm* armor)
{
	return TransformUtils::TransformArmor(actor, static_cast<RE::TESObjectARMO*>(armor));
}

static inline void DumpArmors(RE::StaticFunctionTag*) { TransformUtils::DumpArmors(); };

extern "C" DLLEXPORT bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* a_skse)
{
	auto path = logger::log_directory();
	if (!path) {
		return false;
	}

	*path /= std::string(Plugin::NAME) + ".log";
	auto sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(path->string(), true);
	auto log = std::make_shared<spdlog::logger>("global log", std::move(sink));

	log->set_level(spdlog::level::info);
	log->flush_on(spdlog::level::info);

	spdlog::set_default_logger(std::move(log));
	spdlog::set_pattern("[%^%l%$] %v"s);

	logger::info("{} v{}.{}.{}", Plugin::NAME, Plugin::VERSION[0], Plugin::VERSION[1], Plugin::VERSION[2]);

	SKSE::Init(a_skse);

	auto RegisterPapyrusFuncs = [](RE::BSScript::IVirtualMachine* a_vm) -> bool {
		a_vm->RegisterFunction("TransformArmor", "TransformUtils", TransformArmor);
		a_vm->RegisterFunction("DumpArmors", "TransformUtils", DumpArmors);
		return true;
	};

	auto papyrus = SKSE::GetPapyrusInterface();
	if (!papyrus->Register(RegisterPapyrusFuncs)) {
		logger::critical("Failed to register papyrus callback");
		return false;
	}

	return true;
}
