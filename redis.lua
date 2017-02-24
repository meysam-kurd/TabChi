--[[
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHAlocal Redis = (loadfile "lua-redis.lua")()
local FakeRedis = (loadfile "fakeredis.lua")()

local params = {
  host = '127.0.0.1',
  port = 6379,
}

-- Overwrite HGETALL
Redis.commands.hgetall = Redis.command('hgetall', {
  response = function(reply, command, ...)
    local new_reply = { }
    for i = 1, #reply, 2 do new_reply[reply[i]] = reply[i + 1] end
    return new_reply
  end
})

local redis = nil

-- Won't launch an error if fails
local ok = pcall(function()
  redis = Redis.connect(params)
end)

if not ok then

  local fake_func = function()
    print('\27[31mCan\'t connect with Redis, install/configure it!\27[39m')
  end
  fake_func()
  fake = FakeRedis.new()

  print('\27[31mRedis addr: '..params.host..'\27[39m')
  print('\27[31mRedis port: '..params.port..'\27[39m')

  redis = setmetatable({fakeredis=true}, {
  __index = function(a, b)
    if b ~= 'data' and fake[b] then
      fake_func(b)
    end
    return fake[b] or fake_func
  end })

end


return redis
NTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
]]--

-- Vector example form is like this: {[0] = v} or {v1, v2, v3, [0] = v}
-- If false or true crashed your telegram-cli, try to change true to 1 and false to 0

-- Main Bot Framework
local M = {}

-- @chat_id = user, group, channel, and broadcast
-- @group_id = normal group
-- @channel_id = channel and broadcast
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {ID = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {ID = group_id, type = 'group'}
  end

  return chat
end

local function getInputMessageContent(file, filetype, caption)
  if file:match('/') or file:match('.') then
    infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
    infile = {ID = "InputFileId", id_ = file}
  else
    infile = {ID = "InputFilePersistentId", persistent_id_ = file}
