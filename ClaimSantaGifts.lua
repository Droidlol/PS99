-- made by discord.gg/virtuehub

-- Locals

local HttpService = game:GetService("HttpService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)
local eventdoor = CFrame.new(177.613953, 15.9911404, -143.833618, -0.999994993, 4.56833504e-08, 0.00316533819, 4.53755753e-08, 1, -9.73043797e-08, -0.00316533819, -9.71602674e-08, -0.999994993)

local changeddistance = 5
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local changedeventdoor = eventdoor + (eventdoor.LookVector * changeddistance)

-- Variables

local claimedParts = {}

-- Functions

local function antiAfk()
    local vu = game:GetService("VirtualUser")
    while true do
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
        task.wait(_G.antiAfkInterval)
    end
end


local function sendInitialWebhook()
    if _G.webhookURL == "" then return end

    local payload = {
        username = "Virtue Hub",
        avatar_url = "https://cdn.discordapp.com/attachments/1319992989594030126/1320100746745741403/Virtue_Hub_Logo.png?ex=67685f20&is=67670da0&hm=7a35195b0d68c759320751c5720f09c4a4293fd04ff397b6bcb4f8430a5004c8&",
        content = "",
        embeds = {
            {
                title = "Script Initialized",
                type = "rich",
                color = 65280,
                fields = {
                    { name = "Author", value = "This script was made by Destiny (pq3e)", inline = false },
                    { name = "More Scripts", value = "[Join VirtueHub](https://discord.gg/virtuehub)", inline = false }
                },
                footer = { text = "Enjoy using the script!", icon_url = "https://cdn.discordapp.com/attachments/1319992989594030126/1320100746745741403/Virtue_Hub_Logo.png?ex=67685f20&is=67670da0&hm=7a35195b0d68c759320751c5720f09c4a4293fd04ff397b6bcb4f8430a5004c8&" }
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
        warn("Initial webhook failed")
    end
end

local function sendWebhook(partName)
    if _G.webhookURL == "" then return end

    local payload = {
        username = "Virtue Hub",
        avatar_url = "https://cdn.discordapp.com/attachments/1319992989594030126/1320100746745741403/Virtue_Hub_Logo.png?ex=67685f20&is=67670da0&hm=7a35195b0d68c759320751c5720f09c4a4293fd04ff397b6bcb4f8430a5004c8&",
        content = "Found A Present",
        embeds = {
            {
                title = "Claimed A Present",
                type = "rich",
                color = 1127128,
                fields = {
                    { name = "Present Name: ", value = partName, inline = false },
                    { name = "More Scripts", value = "[Join VirtueHub](https://discord.gg/virtuehub)", inline = false }
                },
                footer = { text = "Thanks For Using Virtue Hub", icon_url = "https://cdn.discordapp.com/attachments/1319992989594030126/1320100746745741403/Virtue_Hub_Logo.png?ex=67685f20&is=67670da0&hm=7a35195b0d68c759320751c5720f09c4a4293fd04ff397b6bcb4f8430a5004c8&" }
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

coroutine.wrap(antiAfk)()
sendInitialWebhook()

if character and _G.tptoeventdoor then
    local humanoidrootpart = character:WaitForChild("HumanoidRootPart")
    humanoidrootpart.CFrame = changedeventdoor
end

task.wait(1)

while true do
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:FindFirstChild("ClickDetector") and 
           part:FindFirstChild("Particles") and 
           part:FindFirstChild("AlignOrientation") and 
           part:FindFirstChild("Attachment") and 
           part:FindFirstChild("ParticleEmitter") then

            if not claimedParts[part] then
                claimedParts[part] = true
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                local args = { [1] = part.Name }
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Christmas Sleigh: Claim"):InvokeServer(unpack(args))
                sendWebhook(part.Name)
                part:Destroy()
                wait(_G.invokeDelay)
            end
        end
    end
    wait(_G.checkDelay)
end
