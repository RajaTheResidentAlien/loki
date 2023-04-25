--Vox(softcut)-page parameters
lfoz=require('lfo') poslfoz={} include("loki/lib/voic")

function recstut(num,idx) clock.sync(num) params:set("V"..idx.."_Rc",0) end --4 auto/short-length recording into stutter

  for i=1,6 do
    local itbl={} local indx=1 local modez={"St","Dl","Lp"}
    local voices={} voices[i] = Voic:new(i) 
    
    poslfoz[i] = lfoz.new() poslfoz[i]:set('shape', 'saw') poslfoz[i]:set('min', 0.0) poslfoz[i]:set('max', 1.0)
    poslfoz[i]:set('depth', 1.0) poslfoz[i]:set('mode', 'clocked') poslfoz[i]:set('period', 3) poslfoz[i]:set('ppqn', 48)
    poslfoz[i]:set('action', function(scld,raw) params:set("V"..i.."_Scrll",util.round(scld,0.0001)) end)

    params:add_group("V"..i.."_Grp","V"..i.."_Group",28)
    params:add_number("V"..i.."_Go","V"..i.."_Play",0,1,0)
    params:set_action("V"..i.."_Go", function(ply) voices[i]:go(ply) end)
    params:add_number("V"..i.."_Rc","V"..i.."_Rec",0,1,0)
    params:set_action("V"..i.."_Rc", function(rec) voices[i]:rec(rec) end)
    params:add{type = "option", id = "V"..i.."_Mod", name = "V"..i.."_Mode", options = modez, default = 1,
      action = function(mdz) voices[i]:mode(mdz) end}
    params:add_number("V"..i.."_Len","V"..i.."_Length",0.0,48.0,1.0)
    params:set_action("V"..i.."_Len", function(lnth) voices[i]:length(lnth) end)
    params:add_number("V"..i.."_Lns","V"..i.."_LengthInSec",0.0,24.0,1.0)
    params:set_action("V"..i.."_Lns", function(lnth) voices[i]:lninsec(lnth) end)
    params:add_number("V"..i.."_LpNum", "V"..i.."_LoopNumber",0,64,0)
    params:set_action("V"..i.."_LpNum", function(lpno) end)
    params:add_number("V"..i.."_Impatnz","V"..i.."_Impatienz",0,64,3)
    params:set_action("V"..i.."_Impatnz", function(impat) lpcount[i]=0 end)
    params:add_number("V"..i.."_Fbk","V"..i.."_Feedback",0.0,1.0,0.0)
    params:set_action("V"..i.."_Fbk", function(fbk) softcut.pre_level(i,fbk) end)
    params:add_number("V"..i.."_Scrll","V"..i.."_ScrollPosition",0.0,1.0,0.0)
    params:set_action("V"..i.."_Scrll", function(scrll) voices[i]:scroll(scrll) end)
    params:add_number("V"..i.."_Spd","V"..i.."_Speed",-2.0,2.0,1.0)
    params:set_action("V"..i.."_Spd", function(spd) softcut.rate(i,spd) end)
    params:add_number("V"..i.."_Pn","V"..i.."_Pan",0.0,1.0,0.5)
    params:add_number("V"..i.."_Vol","V"..i.."_Volume",0.0,2.0,1.0)
    params:set_action("V"..i.."_Vol", function(vol) softcut.level(i,vol) end)
    params:add_number("V"..i.."_Bar","V"..i.."_BarLength",1,32,8)
    params:add_number("V"..i.."_ARc","V"..i.."AmpTrigRec",0,1,1)
    params:add_number("V"..i.."_ALn","V"..i.."AmpTrigLen",0,1,0)
    params:add_number("V"..i.."_PLn","V"..i.."PitchTrigLen",0,1,0)
    params:add_number("V"..i.."_APs","V"..i.."AmpTrigPos",0,1,0)
    params:add_number("V"..i.."_ASp","V"..i.."AmpTrigSpd",0,1,0)
    
    for j=1,6 do if i==j then else itbl[indx]=j indx=indx+1 end end
    params:add{type = "option", id = "V"..i.."_In", name = "V"..i.."_Input",
    options = {"En","I1","I2","V"..itbl[1],"V"..itbl[2],"V"..itbl[3],"V"..itbl[4],"V"..itbl[5]}, default = 1,
    action = function(inz) voices[i]:inputselect(inz, itbl) end}
    poslfoz[i]:add_params('pos_lfo'..i, 'position'..i, 'LFO'..i)
  end

function vpwrit(nam)
  local wriitab={}
  for i=1,6 do
    wriitab["V"..i.."_Go"]=params:get("V"..i.."_Go") wriitab["V"..i.."_Rc"]=params:get("V"..i.."_Rc")
    wriitab["V"..i.."_Mod"]=params:get("V"..i.."_Mod") wriitab["V"..i.."_Len"]=params:get("V"..i.."_Len")
    wriitab["V"..i.."_Impatnz"]=params:get("V"..i.."_Impatnz") wriitab["V"..i.."_Fbk"]=params:get("V"..i.."_Fbk")
    wriitab["V"..i.."_Scrll"]=params:get("V"..i.."_Scrll") wriitab["V"..i.."_Spd"]=params:get("V"..i.."_Spd")
    wriitab["V"..i.."_Pn"]=params:get("V"..i.."_Pn") wriitab["V"..i.."_Vol"]=params:get("V"..i.."_Vol")
    wriitab["V"..i.."_Bar"]=params:get("V"..i.."_Bar") wriitab["V"..i.."_In"]=params:get("V"..i.."_In")
    wriitab["V"..i.."_ALn"]=params:get("V"..i.."_ALn") wriitab["V"..i.."_PLn"]=params:get("V"..i.."_PLn")
    wriitab["V"..i.."_APs"]=params:get("V"..i.."_APs") wriitab["V"..i.."_ASp"]=params:get("V"..i.."_ASp")
    wriitab["V"..i.."_Lns"]=params:get("V"..i.."_Lns") wriitab["V"..i.."_ARc"]=params:get("V"..i.."_ARc")
  end
  tab.save(wriitab,_path.data.."loki/"..nam)
end

function vpread(nam)
  local err local reeadtab={} reeadtab,err=tab.load(_path.data.."loki/"..nam)
  if err==nil then
    for i=1,6 do
      if pfreez[i]<1 then
      params:set("V"..i.."_Mod", reeadtab["V"..i.."_Mod"]) params:set("V"..i.."_Len", reeadtab["V"..i.."_Len"])
      params:set("V"..i.."_Go", reeadtab["V"..i.."_Go"]) params:set("V"..i.."_Rc", reeadtab["V"..i.."_Rc"])
      params:set("V"..i.."_Impatnz", reeadtab["V"..i.."_Impatnz"]) params:set("V"..i.."_Fbk", reeadtab["V"..i.."_Fbk"])
      params:set("V"..i.."_Scrll", reeadtab["V"..i.."_Scrll"]) params:set("V"..i.."_Spd", reeadtab["V"..i.."_Spd"])
      params:set("V"..i.."_Pn", reeadtab["V"..i.."_Pn"]) params:set("V"..i.."_Vol", reeadtab["V"..i.."_Vol"])
      params:set("V"..i.."_Bar", reeadtab["V"..i.."_Bar"]) params:set("V"..i.."_In", reeadtab["V"..i.."_In"])
      params:set("V"..i.."_ALn", reeadtab["V"..i.."_ALn"]) params:set("V"..i.."_PLn", reeadtab["V"..i.."_PLn"])
      params:set("V"..i.."_APs", reeadtab["V"..i.."_APs"]) params:set("V"..i.."_ASp", reeadtab["V"..i.."_ASp"])
      params:set("V"..i.."_Lns", reeadtab["V"..i.."_Lns"]) params:set("V"..i.."_ARc", reeadtab["V"..i.."_ARc"])
      end
end end end