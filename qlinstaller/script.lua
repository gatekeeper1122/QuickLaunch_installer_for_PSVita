--[[ 
	QuickLanch Installer
	
	Licensed by GNU General Public License v3.0
	
	(c) 2017 by lupus
	based on sources from Team OneLua
]]

game.close()
color.loadpalette()

-- Functions
dofile("system/commons.lua")

-- Set path (GLOBAL)
__UXPATH = "ux0:data/qlinstall/"
files.mkdir(__UXPATH)
__URPATH = "ur0:shell/whats_new/np/"

-- Copy sample data to ux0:data/qlinstall
if not files.exists(__UXPATH.."app01.png") then files.copy("resources/installer/app01.png",__UXPATH) end
if not files.exists(__UXPATH.."app02.png") then files.copy("resources/installer/app02.png",__UXPATH) end
if not files.exists(__UXPATH.."app03.png") then files.copy("resources/installer/app03.png",__UXPATH) end
if not files.exists(__UXPATH.."whatsnew.xml") then files.copy("resources/installer/whatsnew.xml",__UXPATH) end
if not files.exists(__UXPATH.."userapps.ini") then files.copy("resources/installer/userapps.ini",__UXPATH) end

-- Loading UI GFX
back = image.load("resources/back.jpg")
box = image.load("resources/box.png")
battery = image.load("resources/battery.png")
defapp01 = image.load ("resources/installer/app01.png")
defapp02 = image.load ("resources/installer/app02.png")
defapp03 = image.load ("resources/installer/app03.png")
userapp01 = image.load (__UXPATH.."app01.png")
userapp02 = image.load (__UXPATH.."app02.png")
userapp03 = image.load (__UXPATH.."app03.png")

-- Reading system language
__LANG = os.language()

-- Loading sa0 fonts and setting up
setupfonts()

-- Loading Special chars 
preloadsymbols()

-- reading lang strings from ux0:data/qlinstall/ if exist
if files.exists(__UXPATH.."lang/"..__LANG..".txt") then dofile(__UXPATH.."lang/"..__LANG..".txt")
else 
-- reading lang strings fom app folder if exist
	if files.exists("resources/lang/"..__LANG..".txt") then dofile("resources/lang/"..__LANG..".txt")
-- checking missing strings in translation file
	local cont = 0
	for key,value in pairs(strings) do cont += 1 end
	if cont < 23 then files.copy("resources/lang/english_us.txt",__UXPATH.."lang/") dofile("resources/lang/english_us.txt") end
-- reading default lang strings if no one translations founded or translation have missed strings
else files.copy("resources/lang/english_us.txt",__UXPATH.."lang/") dofile("resources/lang/english_us.txt") end
end

-- reading app version from .sfo
sfo = game.info("sce_sys/param.sfo")
if sfo then
ver = sfo.APP_VER
end

if os.access() == 0 then
	if back2 then back2:blit(0,0) end 
	screen.flip()
	custom.message(strings.unsafe,0)
	os.exit()
end

-- Auto-Update
dofile("git/updater.lua")

------------------------------------------Main--------------------------------------------------------------
 -- Read userdata from .ini if exists (just once)
 if files.exists(__UXPATH.."userapps.ini") then __PATHINI=(__UXPATH.."userapps.ini")
  __APP01SHOW = tonumber(ini.read(__PATHINI,"app01","show",1))
  __APP02SHOW = tonumber(ini.read(__PATHINI,"app02","show",1))
  __APP03SHOW = tonumber(ini.read(__PATHINI,"app03","show",1))
  __APP01PATH = tostring(ini.read(__PATHINI,"app01","path",1))
  __APP02PATH = tostring(ini.read(__PATHINI,"app02","path",1))
  __APP03PATH = tostring(ini.read(__PATHINI,"app03","path",1))
 end

__XMLS01  = "<nsx><spc>"
__XMLS020 = "<mtrl anno=\"\" from=\"2001-01-01T00:00:00.000Z\" id=\"0\" lastm=\"2001-01-01T00:00:00.000Z\" mname=\"\" until=\"2100-12-31T23:59:00.000Z\">"
__XMLS021 = "<mtrl anno=\"\" from=\"2001-01-01T00:00:00.000Z\" id=\"1\" lastm=\"2001-01-01T00:00:00.000Z\" mname=\"\" until=\"2100-12-31T23:59:00.000Z\">"
__XMLS031 = "<url>app01.png</url>"
__XMLS032 = "<url>app02.png</url>"
__XMLS033 = "<url>app03.png</url>"
__XMLS041 = "<target type=\"u\">psgm:play?titleid="..__APP01PATH.."</target>"
__XMLS042 = "<target type=\"u\">psgm:play?titleid="..__APP02PATH.."</target>"
__XMLS043 = "<target type=\"u\">psgm:play?titleid="..__APP03PATH.."</target>"
__XMLS05  = "<cntry agelmt=\"0\">all</cntry> <lang>all</lang></mtrl>"
__XMLS06  = "</spc></nsx>"
 
options = { strings.menuline01, strings.menuline02, strings.menuline03, strings.menuline04}
sel = 1

buttons.interval(10,12)
while true do
	buttons.read()

	if back then back:blit(0,0) end
	draw.fillrect(0,0,960,30, 0x64545353) -- caption bg
	batx = 910
	baty = 6
	battpercent = batt.lifepercent()
	 draw.fillrect(batx,baty+5,3,10, color.white:a(150))    -- draw battery contour -- 3 strings
	 draw.fillrect(batx+3,baty,37,20, color.white:a(150))
	 draw.fillrect(batx+5,baty+2,33,16, color.black:a(50))
	if battpercent >= 80 then draw.fillrect(batx+38,baty+2,-33,16, color.green:a(150)) end
	if battpercent >= 60 and battpercent <80 then draw.fillrect(batx+38,baty+2,-27,16, color.green:a(150)) end
	if battpercent >= 40 and battpercent <60 then draw.fillrect(batx+38,baty+2,-21,16, color.green:a(150)) end
    if battpercent >= 20 and battpercent <40 then draw.fillrect(batx+38,baty+2,-14,16, color.green:a(150)) end
    if battpercent >= 1 and battpercent <20 then draw.fillrect(batx+38,baty+2,-7,16, color.red:a(150)) end	
	screen.print(10,7,strings.caption.." v"..ver,1,color.white,color.blue,__ALEFT)
	time_format = os.getreg("/CONFIG/DATE/", "time_format" , 1)
	 if time_format == 0 
	  then screen.print(900,7,os.date("%d/%m/%y  %x"),1,color.white,color.blue,__ARIGHT)
	  else screen.print(900,7,os.date("%d/%m/%y  %X"),1,color.white,color.blue,__ARIGHT)
	 end

	local y = 45
	for i=1,#options do
		if i == sel then
			draw.fillrect(40,y-2,360,21, color.blue:a(150)) 
			draw.rect(40,y-2,360,21, color.green:a(100)) 
		end
		screen.print(49,y,options[i],1.0,color.white,color.gray,__ALEFT)
		y += 25
	end

    if sel == 1 then modprev01() end
--	if sel == 2 then modprev02() end

	screen.flip()
	
	--Controls
	if buttons.up then sel-=1 end
	if buttons.down then sel+=1 end

	if sel > #options then sel=1 end
	if sel < 1 then sel=#options end

	if buttons.cross then
		if sel == 1 then if custom_msg(strings.qlinst01,1) == true then modinstall01() end
		elseif sel == 2 then modinstall02() --custom_msg(strings.qlinst02,1) == true then modinstall02() end
			elseif sel == 3 then if custom_msg(strings.cleardata,1) == true then modreset() end
				elseif sel == 4 then os.exit() buttons.homepopup(1)
		end
	end
    
end
