local https = require('ssl.https')
local ltn12 = require('ltn12')

local secrets = require('secrets')

https.TIMEOUT= 10 
local link = 'https://api.twitter.com/1.1/friends/list.json?cursor=-1&screen_name={SCREEN_NAME}&skip_status=true&include_user_entities=false'
local resp = {}
local body, code, headers = https.request{
  url = link,
  content_type = 'application/json',
  headers = { 
    ['Referer'] = link,
    ['Connection'] = 'keep-alive',
    ['authorization'] = 'Bearer ' .. secrets.BEARER_TOKEN
  },         
  sink = ltn12.sink.table(resp)
}   

if code~=200 then 
  print("Error: ".. (code or '') ) 
  print("response: ".. table.concat(resp))
  return 
end

print("Status:", body and "OK" or "FAILED")
print("HTTP code:", code)
print("Response headers:")
if type(headers) == "table" then
  for k, v in pairs(headers) do
    print(k, ":", v)        
  end
end

print(table.concat(resp))
