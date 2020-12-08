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
		return 1
	end
	end
	return false
end

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
	if not contains(whitelist, data.FromGroupId) then
		return 1
	end

	if data.FromUserId == 993846145 then
		return 1
	end

	for i = 1, #blacklist do
		if (string.match(data.Content, blacklist[i]) == blacklist[i]) then
			LuaRes =
			Api.Api_SendMsgV2(
				CurrentQQ,
				{
					ToUserUid = data.FromGroupId,
					SendToType = 2,
					SendMsgType = "TextMsg",
					Content = "请勿在群内沟通敏感信息[表情14]"
				}
			)

			log.notice("From Lua SendMsg Ret-->%d", LuaRes.Ret)

			Api.Api_CallFunc(CurrentQQ,"PbMessageSvc.PbMsgWithDraw",{GroupID = data.FromGroupId, MsgSeq = data.MsgSeq, MsgRandom = data.MsgRandom})

		end
	end

	return 1
end

function ReceiveEvents(CurrentQQ, data)
	return 1
end

function GroupMsgParseMsg(CurrentQQ, data)
	return 1
end
