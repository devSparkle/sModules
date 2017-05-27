--// Initialization

local HttpService	= game:GetService("HttpService")

local Boards		= {}
local Cards			= {}

local Module		= {}

--// Variables

local TrelloBaseURL	= "https://api.trello.com"

local APIKey		= ""
local APIToken		= ""

Module.DebugMode	= true

--// Functions

local function EncodeQueryString(URL, Query)
	assert(Query == nil or type(Query) == "table", "Query must be a table of URL Parameters")

	local IsFirstValue	= true
	local EncodedURL	= URL

	for QueryName, QueryValue in next, Query do
		if IsFirstValue then
			IsFirstValue	= false
			EncodedURL		= EncodedURL .. "?" .. QueryName .. "=" .. QueryValue
		else
			EncodedURL		= EncodedURL .. "&" .. QueryName .. "=" .. QueryValue
		end
	end

	return EncodedURL
end

setmetatable(Boards, {
	__index = function(Boards, BoardID)
		local Board			= {}
		Board.BoardID		= BoardID
		Board.BaseURL		= TrelloBaseURL .. "/1/boards/" .. BoardID
		
		Boards[BoardID]		= Board
		return Board
	end
})

function Module:GetBoard(BoardID)
	return Boards[BoardID]
end

return Module