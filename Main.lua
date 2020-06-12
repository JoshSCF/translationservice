-- joshrbx was here, hi

local Http = game:GetService("HttpService")

local PublicKey = {
	Yandex = "REMOVED",
	Google = "REMOVED",
	Microsoft = "REMOVED"
}

local GetTranslation = {
	Yandex = function(str, lang, Orig, Key)
		local URL = "https://translate.yandex.net/api/v1.5/tr.json/translate?key="
		..Key.."&text="..str.."&lang="..Orig.."-"..lang
		
		return Http:JSONDecode(Http:GetAsync(URL)).text[1]
	end,
	
	Google = function(str, lang, Orig, Key)
		local URL = "https://translation.googleapis.com/language/translate/v2?key="
		..Key.."&q="..str.."&source="..Orig.."&target="..lang
		
		return Http:JSONDecode(Http:GetAsync(URL)).data.translations[1].translatedText
	end,
	
	Microsoft = function(str, lang, Orig, Key)
		local URL = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from="
		..Orig.."&to="..lang
		
		return Http:JSONDecode(
			Http:RequestAsync(
				{
					Url = URL,
					Method = "POST",
					Headers = {
						["Ocp-Apim-Subscription-Key"] = Key,
						["Content-Type"] = "application/json",
					},
					Body = Http:JSONEncode({{Text = str}})
				}
			).Body
		)[1].translations[1].text
	end
}

return {
	Translate = function(str, lang, original, key, service)
		local Orig = original or "en"
		local Service = service or "Yandex"
		local Key = key or PublicKey[Service]
		local Languages = require(script[Service])
		
		Orig = #Orig > 3 and Languages[Orig:lower()] or Orig
		lang = #lang <= 3 and lang or Languages[lang:lower()]
		
		return GetTranslation[Service](str, lang, Orig, Key)
	end,
	
	Languages = {
		Google = require(script.Google),
		Yandex = require(script.Yandex),
		Microsoft = require(script.Microsoft)
	}
}