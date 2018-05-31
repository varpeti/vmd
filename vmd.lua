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

function match(line,pat,ret)
    local s = {line:match(pat)}
    for i,v in ipairs(s) do
        ret[i]=v
    end
    return ret[1]~=nil
end


function hardmath(str,b)
    if b then
        str = str:gsub("[_](.*)[_]","_{%1}")
        str = str:gsub("[%[](.*)[%]]","_{%1}")
        str = str:gsub("[%^](.*)[%^]","^{%1}")

        str = str:gsub("(.*)[(]([^;]*);([^;]*);","%1_{%2}^{%3}(")
    end

    return "`"..str.."`"
end


local tab = 0
local space = "    "
function aprint(str)
    for i=1,tab do
        io.write(space)
    end
    --Text format
    str = str:gsub("[*][*](.*)[*][*]","<b>%1</b>")
    str = str:gsub("[-][-](.*)[-][-]","<u>%1</u>")
    str = str:gsub("[/][/](.*)[/][/]","<i>%1</i>")
    str = str:gsub("[~][~](.*)[~][~]","<del>%1</del>")
    str = str:gsub("[_][_](.*)[_][_]","<sub>%1</sub>")
    str = str:gsub("[%^][%^](.*)[%^][%^]","<sup>%1</sup>")
    str = str:gsub("[#](%x%x%x%x%x%x)(.*)[#]","<span style='color:#%1;'>%2</span>")
    str = str:gsub("[@](%x%x%x%x%x%x)(.*)[@]","<span style='background-color:#%1;'>%2</span>")
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
        if match(line,"^```(.*)",s) then 
            print("</code></pre>") code=false 
        else
            print(line)
        end

    else
        line = line:gsub("[<]","&lt")
        line = line:gsub("[>]","&gt")

        --Title
        if match(line,"^#%s(.*)",s) then tab=1 aprint("<h1>"..s[1].."</h1>") tab=2
        elseif match(line,"^##%s(.*)",s) then tab=1  aprint("<h2>"..s[1].."</h2>") tab=2
        elseif match(line,"^###%s(.*)",s) then tab=1  aprint("<h3>"..s[1].."</h3>") tab=2
        elseif match(line,"^####%s(.*)",s) then tab=1  aprint("<h4>"..s[1].."</h4>") tab=2
        elseif match(line,"^#####%s(.*)",s) then tab=1  aprint("<h5>"..s[1].."</h5>") tab=2
        elseif match(line,"^######%s(.*)",s) then tab=1  aprint("<h6>"..s[1].."</h6>") tab=2
    
        --Math
        elseif match(line,"^[%$][%$]@(.*)",s) then aprint("<div class='math'>") tab=tab+1 aprint(hardmath(s[1],true)) tab=tab-1 aprint("</div>")
        elseif match(line,"(.*)[%$][%$]@(.*)[%$][%$](.*)",s) then aprint(s[1]..hardmath(s[2],true)..s[3])
        elseif match(line,"^[%$][%$](.*)",s) then aprint("<div class='math'>") tab=tab+1 aprint(hardmath(s[1],false)) tab=tab-1 aprint("</div>")
        elseif match(line,"(.*)[%$][%$](.*)[%$][%$](.*)",s) then aprint(s[1]..hardmath(s[2],false)..s[3])
    
        --Code
        elseif match(line,"^```(.*)",s) then io.write("<pre><code class='"..s[1].."'>") code=true

        --Link
        elseif match(line,"link=(.*);(.*);",s) then aprint("<a href='"..s[1].."'>"..s[2].."</a>")

        --Image
        elseif match(line,"img=(.*);(.*);",s) then aprint("<img src='"..s[1].."' alt='"..s[2].."'>")

        --Paragraph
        elseif match(line,"^$",s) then tab=1 aprint("</p>") aprint("<p>") tab=2
        else aprint(line.."<br>")
        end
    end

end

print(html["end"])