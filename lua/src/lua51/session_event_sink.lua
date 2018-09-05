
--- session event sink

local class = require('class')

local session_event_sink = class()

--- session connecting failure
-- @param session
-- @param reason
function session_event_sink:on_session_connecting_failure(session, reason)
end

--- session connection event
function session_event_sink:on_session_connected(session)
end

--- perform authentication after session connected
-- @param session
-- @return true | false, err
function session_event_sink:on_session_authentication(session)

end

--- session disconnection event
-- @param session
-- @param reason
function session_event_sink:on_session_disconnected(session, reason)
end

return session_event_sink
