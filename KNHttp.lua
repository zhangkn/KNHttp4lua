--local json = require "json"
local sz = require("sz")
local json = sz.json
local http = require("szocket.http")
require "TSLib"



local globalIOS8 = -1
local globalIOS9 = -1

function isiOS8()

	if globalIOS8 == -1 then
		if  string.byte( osversion ,1) == string.byte( "8" ,1) then
			globalIOS8 = 1
		else
			globalIOS8 = 0
		end	 
	end

	return globalIOS8 == 1
end

function isiOS9()
	if globalIOS9 == -1 then
		if  string.byte( osversion ,1) == string.byte( "9" ,1) then
			globalIOS9 = 1
		else
			globalIOS9 = 0
		end	 
	end

	return globalIOS9 == 1

end

function isiOS10()
	return isiOS8() == false and isiOS9() == false
end





w,h = getScreenSize()



function clearDeviceData(...)
	clearPasteboard()--清除设备剪贴板信息
	clearCookies() --清除浏览器Cookies信息
end


function click2(pt)
	touchDown(pt.x, pt.y)
	mSleep(60)
	touchUp(pt.x, pt.y)
end

function click(x, y)
	touchDown(x, y)
	mSleep(60)
	touchUp(x, y)
end


function findMultiColorInRect( colorTable , rc )
	x,y=findMultiColorInRegionFuzzyByTable(colorTable,90, rc.x1 , rc.y1 , rc.x2 , rc.y2 )
	return x,y
end

function findMultiColorInRectBool( colorTable , rc )
	x,y=findMultiColorInRegionFuzzyByTable(colorTable,90, rc.x1 , rc.y1 , rc.x2 , rc.y2 )
	if x ~= -1 and y ~= -1 then
		return true
	else
		return false
	end
end

--return handled
function findAndClick( colorTable , rc )

	x,y= findMultiColorInRect( colorTable , rc)

	if x ~= -1 and y ~= -1 then
		mSleep(500)
		click(x,y)
		return true
	else
		return false
	end

end


local myToken = "dinghao"

function httpPost( http_url , content_type , http_body  )
    
    sysLog("《httpPost start 》http_url： "..http_url);
    sysLog("content_type： "..content_type);
    sysLog("http_body :")
    if type(http_body) == "table" then
        sysLog(table.concat(http_body))
        else
        if(not(http_body == nil)) then
            sysLog("Not a table:"..http_body)
        end
    end
    
    
	local response_body = {}  
	local res, code, response_headers = http.request{  
		url = http_url,  
		method = "POST",  
		headers =  
		{  
			["Content-Type"] = content_type;  
			["Content-Length"] = #http_body;  
		},  
		source = ltn12.source.string(http_body),  
		sink = ltn12.sink.table(response_body),  
	}
    decode3 = {};
    --notifyMessage("res is:"..res);
    sysLog("《httpPost end 》");
    if(not(res == nil)) then
        sysLog("res:"..res);
        
    else
    --code： timeout
    res= "";
    sysLog("code： "..code);
    
    --输出返回的信息到特定文件
    
    -- 以附加的方式打开只写文件
    file = io.open("/var/root/lualog.text", "a")
    -- 在文件最后一行添加 Lua 注释
    -- 设置默认输出文件为 test.lua
    io.output(file)
    
    if type(response_body) == "table" then
        file:write("--res:"..res.." code:"..code.." response_body:"..table.concat(response_body).."\n")
        else
        file:write("--res:"..res.." code:"..code.." response_body[1]:"..type(response_body).."\n")
    end
    
    -- 关闭打开的文件
    file:close()

    return res,code,decode3
    
    end
    sysLog("code： "..code);
    
    
    
    sysLog("Response body:")
    if type(response_body) == "table" then
        sysLog("《"..table.concat(response_body).."》")
        else
        sysLog("Not a table:", type(response_body))
    end
    
    
    if (not(response_body[1] == nil)) then
        decode3 = json.decode( response_body[1] )--第一个元素是string
      
     end
        
    
	return res,code,decode3
end

function httpPostJson(http_url , json_body_table )
	assert( type(json_body_table) == "table" )
	return httpPost(http_url,"application/json; charset=UTF-8", json.encode( json_body_table ) )
end


local globalURL = ""


local smsStatusProcessing = 2
local smsStatusFailed = 3
local smsStatusFinished = 4
