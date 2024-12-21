-- made by pq3e on discord
local HttpService = game:GetService("HttpService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)

local function sendWebhook(partName)
    if _G.webhookURL == "" then return end

    local payload = {
        username = "Nigger Claimer",
        avatar_url = "https://m.media-amazon.com/images/I/51zeQVfZ2OL._UXNaN_FMjpg_QL85_.jpg",
        content = "Found A Present",
        embeds = {
            {
                title = "Claimed A Present",
                type = "rich",
                color = 1127128,
                fields = {
                    { name = "Present Name: ", value = partName, inline = false }
                },
                footer = { text = "Nigger Claimer", icon_url = "https://m.media-amazon.com/images/I/51zeQVfZ2OL._UXNaN_FMjpg_QL85_.jpg" }
            }
        }
    }

    local response = httpRequest({
        Url = _G.webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    })

    if not response or not response.Success then
        warn("Webhook failed")
    end
end

while true do
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:FindFirstChild("ClickDetector") or part:FindFirstChild("Particles") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
            local partName = part.Name
            local args = { [1] = partName }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Christmas Sleigh: Claim"):InvokeServer(unpack(args))
            sendWebhook(partName)
            wait(1)
        end
    end
    wait(0.1)
end
