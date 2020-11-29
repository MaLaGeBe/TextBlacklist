local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

local whitelist = {43604064,366893831} --群白名单
local blacklist = {
    "vpn",
    "VPN",
    "VPn",
    "Vpn",
    "蓝灯",
    "老王",
    "科学上网",
    "翻墙",
    "快连",
    "绿灯",
}

local function contains(table, val)
    for i = 1, #table do
       if table[i] == val then
          return true
       end
    end
    return false
end

function ReceiveFriendMsg(CurrentQQ, data)
    return true
end

function ReceiveGroupMsg(CurrentQQ, data)
    if not contains(whitelist, data.FromGroupId) then
        return true
    end

    if (CurrentQQ == data.FromUserId) then
        return true
    end

    for i = 1, #blacklist do
        if (string.match(data.Content, blacklist[i]) == blacklist[i]) then
            LuaRes =
            Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "ReplayMsg",
                groupid = 0,
                content = "检测到敏感词汇，请撤回！！！",
                atUser = data.FromUserId,
                replayInfo = {
                    MsgSeq =  data.MsgSeq,
                    MsgTime = data.MsgRandom,
                    UserID = data.FromUserId,
                    RawContent = data.Content
                }
            }
        )

        log.notice("From Lua SendMsg Ret-->%d", LuaRes.Ret)
        -- Api.Api_RevokeMsg(CurrentQQ, data.FromGroupId, data.MsgSeq, data.MsgRandom)
        -- Api.Api_CallFunc(CurrentQQ, "PbMessageSvc.PbMsgWithDraw", {data.FromGroupId, data.MsgSeq, data.MsgRandom})
        end
    end

    return true
end

function ReceiveEvents(CurrentQQ, data)
    return true
end

function GroupMsgParseMsg(CurrentQQ, data)
    return true
end
