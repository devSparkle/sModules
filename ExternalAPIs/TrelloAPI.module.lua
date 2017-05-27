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
	if not Query or type(Query) ~= "table" then
		error("Query must be a table of URL Parameters")
	end
		
	local QueryName, QueryValue = next(Query)
	URL = URL .. "?" .. QueryName .. "=" .. QueryValue

	for QueryName, QueryValue in next, Query, QueryName do
		URL = URL .. "&" .. QueryName .. "=" .. QueryValue
	end

	return URL
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
