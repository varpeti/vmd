function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function minusS(str)
    return str:gsub("%s","_")
end

function plusS(str)
    return str:gsub("[_]"," ")
end

function match(line,pat,ret)
    local s = {line:match(pat)}
    for i,v in ipairs(s) do
        ret[i]=v
    end
    return ret[1]~=nil
end


function hardmath(str,b)
    if b then
        str = str:gsub("[%[](.-)[%]]","_{%1}")

        str = str:gsub("(.-)[(]([^;]-);([^;]-);","%1_{%2}^{%3}(")
    end

    return "`"..str.."`"
end

function premath(str)
    str = str:gsub("[%$][%$][@](.-)[%$][%$]",function(w) return hardmath(w,true ) end)
    str = str:gsub("[%$][%$](.-)[%$][%$]",   function(w) return hardmath(w,false) end) 
    return str
end

local tableOfContents = {}
function printToC(width)
    local mel = {0,0,0,0,0,0}
    print("<div class='img0'><div class='img1'><pre style='background-color: white;'>")
    for k,v in pairs(tableOfContents) do

        mel[v[2]]=mel[v[2]]+1
        for i=v[2]+1,6 do
            mel[i]=0
        end

        local num = ""
        for i=0,5 do
            if mel[6-i]~=0 then
                num = mel[6-i].."."..num
            end
        end

        width = tonumber(width)
        while num:len()<width do
            num=num.."."
        end

        print("<a href='#"..v[1].."' style='color:black;' >"..num..plusS(v[1]).."</a>")
    end
    print("</pre></div></div>")
end


local tab = 0
local space = "    "
function aprint(str)
    for i=1,tab do
        io.write(space)
    end
    --Text format
    str = str:gsub("[*][*](.-)[*][*]","<b>%1</b>")
    str = str:gsub("[-][-](.-)[-][-]","<u>%1</u>")
    str = str:gsub("[/][/](.-)[/][/]","<i>%1</i>")
    str = str:gsub("[~][~](.-)[~][~]","<del>%1</del>")
    str = str:gsub("[_][_](.-)[_][_]","<sub>%1</sub>")
    str = str:gsub("[%^][%^](.-)[%^][%^]","<sup>%1</sup>")
    str = str:gsub("[#](%x%x%x%x%x%x)(.-)[#]","<span style='color:#%1;'>%2</span>")
    str = str:gsub("[@](%x%x%x%x%x%x)(.-)[@]","<span style='background-color:#%1;'>%2</span>")
    io.write(str.."\n")
end

if arg[1] == nil then error("Usage: lua vmd.lua file.vmd [>out.html]") end

local file = arg[1]
local lines = lines_from(file)

local html = require("htmldef")

print(html["begin"])
tab=2

local code = false
for i,line in pairs(lines) do

    local s = {}

    if code then
        if match(line,"^```(.*)$",s) then 
            print("</code></pre></div></div>") code=false 
        else
            print(line)
        end

    else
        line = line:gsub("[<]","&lt")
        line = line:gsub("[>]","&gt")

        --Title
        if     match(line,"^#%s(.*)$",s)      then 
            local m = minusS(s[1])
            aprint("<h1><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h1>")
            table.insert(tableOfContents,{m,1})
        elseif match(line,"^##%s(.*)$",s)     then 
            local m = minusS(s[1])
            aprint("<h2><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h2>")
            table.insert(tableOfContents,{m,2})
        elseif match(line,"^###%s(.*)$",s)    then 
            local m = minusS(s[1])
            aprint("<h3><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h3>")
            table.insert(tableOfContents,{m,3})
        elseif match(line,"^####%s(.*)$",s)   then 
            local m = minusS(s[1])
            aprint("<h4><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h4>")
            table.insert(tableOfContents,{m,4})
        elseif match(line,"^#####%s(.*)$",s)  then 
            local m = minusS(s[1])
            aprint("<h5><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h5>")
            table.insert(tableOfContents,{m,5})
        elseif match(line,"^######%s(.*)$",s) then 
            local m = minusS(s[1])
            aprint("<h6><a id='"..m.."'class='anchor' href='#"..m.."' aria-hidden='true'><span aria-hidden='true' class='octicon octicon-link'></a>"..s[1].."</h6>")
            table.insert(tableOfContents,{m,6})

        --Math
        elseif match(line,"^[%$][%$]@([^$]*)$",s) then aprint("<div class='math'>") tab=tab+1 aprint(hardmath(s[1],true)) tab=tab-1 aprint("</div>")
        elseif match(line,".*[%$][%$].-[%$][%$].*",s) then aprint(premath(line))
        elseif match(line,"^[%$][%$]([^$]*)$",s) then aprint("<div class='math'>") tab=tab+1 aprint(hardmath(s[1],false)) tab=tab-1 aprint("</div>")
    
        --Code
        elseif match(line,"^```(.*)$",s) then io.write("<div class='img0'><div class='img1'><pre><code class='"..s[1].."'>") code=true

        --Link
        elseif match(line,"link=(.-);(.-);",s) then aprint(line:gsub("link=(.-);(.-);","<a href='%1' target='_blank'>%2</a>"))
        elseif match(line,"jump=(.-);(.-);",s) then aprint(line:gsub("jump=(.-);(.-);","<a href='%1'>%2</a>"))

        --Image
        elseif match(line,"img=(.-);(.-);",s) then aprint(line:gsub("img=(.-);(.-);","<div class='img0'><div class='img1'><img src='%1' alt='%2'><div class='img2'>%2</div></div></div>"))

        --Line
        elseif match(line,"^[-][-]+$",s) then aprint("<hr>")
        elseif match(line,"^[=][=]+$",s) then aprint("<hr style='border-top: 5px double;'>")


        elseif match(line,"^:Table of Contents:(%d+):$",s) then printToC(s[1]);

        --Paragraph
        elseif match(line,"^$",s) then tab=1 aprint("</p>") aprint("<p>") tab=2
        else aprint(line.."<br>")
        end
    end

end

print(html["end"])