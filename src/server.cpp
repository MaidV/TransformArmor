#include <mongoose.h>
#include <transform_utils.hpp>
#include <nlohmann/json.hpp>

#include <string>
using std::string;
using nlohmann::json;
using namespace RE;

static void cb(struct mg_connection* c, int ev, void* ev_data, void*)
{
	const char* s_web_root_dir = "data/outfitmanager";
	if (ev == MG_EV_HTTP_MSG) {
		struct mg_http_message* hm = static_cast<mg_http_message*>(ev_data);
		TransformUtils::LoadArmors();

		if (mg_vcmp(&hm->uri, "/LoadArmorData") == 0) {
			spdlog::info("LoadArmorData Request received");
			auto& armors = TransformUtils::GetLoadedArmors();
			mg_http_reply(c,
				200,
				"Content-Type: application/json; charset=utf-8\r\nAccess-Control-Allow-Origin: *\r\n",
				json(armors).dump(-1, ' ', false, json::error_handler_t::ignore).c_str());

			return;
		} else if (mg_vcmp(&hm->uri, "/TryOutfit") == 0) {
			spdlog::info("TryOutfit Request received");
			const char* data = static_cast<const char*>(hm->body.ptr);
			const size_t len = hm->body.len;
			string outfit_str;
			outfit_str.reserve(len + 1);
			for (int i = 0; i < len; ++i)
				outfit_str[i] = data[i];
			outfit_str[len] = '\0';
			spdlog::info(outfit_str);

			TransformUtils::TryOutfit(PlayerCharacter::GetSingleton(), outfit_str.c_str());

			mg_http_reply(c, 200, "Access-Control-Allow-Origin: *\r\n", "");
			return;
		}

		struct mg_http_serve_opts opts = { s_web_root_dir, NULL };
		mg_http_serve_dir(c, hm, &opts);
	}
}

void outfit_server(const int& port, const bool& local_only)
{
	struct mg_mgr mgr;
	mg_mgr_init(&mgr);
	std::string listening_address = (local_only ? "http://localhost:" : "http://0.0.0.0:") + std::to_string(port);
	mg_http_listen(&mgr, listening_address.c_str(), cb, &mgr);
	while (true)
		mg_mgr_poll(&mgr, 1000);
	mg_mgr_free(&mgr);
}
