# KNHttp4lua
function KNreport(report)
    
    if not(type(report) == "table") then
        return;
    end
    
    getnewurl = ""..urlbaseTable[getenv()]..methodurlTable["report"];
    local  res,code,response_body = httpPostJson(getnewurl, report);
    
    --send("timeout")     -- 将生产的物品发送给消费者，告诉后台转换超时
    --send()     -- 将生产的物品发送给消费者
    
    local jsonBody= response_body;
    sysLog("jsonBody :"..table.concat(response_body));
    
    code = jsonBody["Code"];
    sysLog("Code:"..code.."type"..type(Code));           --break;
    
    if( code == 201 ) then--Dec  1 14:43:06 iPhone SM3f5[587] <Warning>: 《{"Code":201,"Msg":"暂无需要转换的淘口令"}》
        
        sysLog("201:");           --break;
        elseif (code == 200 )   then
        sysLog("上报成功！");           --break;
    end
    
    
end
