--! file: pay.lua
local lb_key = KEYS[1]

local from_name = ARGV[1]
local to_name = ARGV[2]
local amount = math.ceil(tonumber(ARGV[3]))

-- sanity checks
if amount < 1 then
    return {"err", false}
end

-- can we pay that much?
local from_current = tonumber(redis.call("zscore", lb_key, from_name))
if not from_current or from_current < amount then
  return {"funds", false}
end

redis.call("zincrby", lb_key, -amount, from_name)
redis.call("zincrby", lb_key, amount, to_name)
return {"OK", amount}