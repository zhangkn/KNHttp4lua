# KNHttp4lua
function KNreport(report)
    
    if not(type(report) == "table") then
        return;
    end
    
    getnewurl = ""..urlbaseTable[getenv()]..methodurlTable["report"];
    local  res,code,response_body = httpPostJson(getnewurl, report);
    
    --send("timeout")     -- 
    --send()     -- 
    
    local jsonBody= response_body;
    sysLog("jsonBody :"..table.concat(response_body));
    
    code = jsonBody["Code"];
    sysLog("Code:"..code.."type"..type(Code));           --break;
    
    if( code == 201 ) then
        
        sysLog("201:");           --break;
        elseif (code == 200 )   then
        sysLog("上报成功！");           --break;
    end
    
    
end
