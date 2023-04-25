--            loki
--        summoned by 
--   raja (TheResidentAlien)
-- see github for manual:
-- https://github.com
-- /RajaTheResidentAlien
--/loki_doc
--
-- few hints...
-- 1) enc1 - select pages
-- 2) enc2 - select params
-- 3) enc3 - change params
-- 4) k3 - activates things
-- 5) k2 - most volatile..
-- ..can trigger record/edit..
-- ..or save over presets.
-- there's also combos..
-- ..of double-k press:
-- k1, then k2 = -1 preset#
-- k1, then k3 = +1 preset#
-- k3, then k2 = echo/rev
-- k2, then k3 = ...
--  ...contextual randomize... 
-- ..loki will play w/ yer mind..
-- ..loki will heart w/ yer play..
-- o_O.thanx for yer mischief.O_o
engine.name='Loki' 
fileselect=require('fileselect') scr=include 'lib/scrn' mutil = require("musicutil")
fildir={_path.audio.."loki/BD/",_path.audio.."loki/SN/",_path.audio.."loki/HH/",_path.audio.."loki/XX/"}
fildrsel=1 filsel=0 sel=-1 sl=1 vsel=1 hsel=-1 edit=0 page=1 uipag=0 spr=0 vpr=0 mpr=0 rdr=0 rdrw=0
pollf=0 pollr=0 plf={0,0,0,0,0,0} go=0 tix=0 tixx=0 keytog=0 fil=0 tempo=0 sprenum=1 vprenum=1 lrn=0
swuiflag=0 swim=0.0 swflag=0 lfprmult=0.5 prmfreez=0 pfreez={0,0,0,0,0,0}
selct={1,1,1,1} pause={0,0,0,0} vpause={0,0,0,0,0,0} --file-'sel'(index) & pause(4 stuttrs to finish)
oone=0 onne=0 two=0 twoo=0 lasknwnpos={0,0,0,0,0,0} --double-press flags and 'last-known-positions'
rezpitchz={44,46,47,49,51,52,55,56,58,59,61,63,64,67,68,70,71,73,75,76} --no reason: just chose a scale(minor starting on 44)
prerecz={0,0,0,0,0,0} lpcount={1,1,1,1,1,1} lplay={1,1,1,1,1,1}
files = {} seq =                          --files/sequencer vals for 4-piece kit(4 voices of 'PlayBuf' in supercollider layer)
{ {1,0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,0,2,0,1,0,0,0,2,1,0,1,0,1,0,0,3,0,1,0,1,0,2,0,0,1,0,0,0,1,0,0,5,0,4,2}, 
  {0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,0,0,0,3,0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,2,0,1,0,0,1,0,0}, 
  {1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,2,3,1,0,1,0,8,2,1,0,1,0,1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,5,3,1,0,8,0,1,2,7,0,1,0},
  {0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,0,1,0,3,0,0,1,0,1,0,0,5,2,0,0,0,0,1,0,1,0,0,3,0,1,0,0,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0}}

function init()
  pollf = poll.set("amp_in_l") pollr = poll.set("amp_in_r")   --setup polls
  pchlf = poll.set("pitch_in_l") pchrt = poll.set("pitch_in_r")
  for i=1,4 do files[i]=util.scandir(fildir[i])  engine.flex(i-1,fildir[i]..files[i][1]) end --register file directories & load files
  sprm=include 'lib/sparamz' vprm=include 'lib/vparamz' miid=include 'lib/miid'  --params(these first for dependencies) + MIDI PgCh
  tempo=params:get("clock_tempo") audio.level_eng_cut(1.0) audio.level_adc_cut(1.0) softcut.event_position(epos)
  pollf.callback = function(val)                                          --poll left                    
    for i=1,6 do                                                    
      if params:get("AT1")>0 then              --"Pll" is an attempt to extend 'hysteresis'..  
        if val>params:get("ATr") and params:get("Pll")<1 then
          if params:get("V"..i.."_ARc")>0 then                  --..for less chance of false-retrigger
            if params:get("V"..i.."_Mod")==3 then 
              prerecz[i]=2 params:set("AT1",0) 
            else params:set("V"..i.."_Rc",1) end 
          end
          if params:get("V"..i.."_ALn")>0 then
            if params:get("V"..i.."_Mod")==3 then prerecz[i]=2 lpcount[i]=1 
            else params:set("V"..i.."_Len",(math.random(64)*2)*0.0078125) end 
          end
          if params:get("V"..i.."_APs")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              if i<3 then softcut.position(i,math.random(0,lasknwnpos[i]+58))
              elseif i>2 and i<5 then softcut.position(i,math.random(0,lasknwnpos[i]+174))
              elseif i>4 then softcut.position(i,math.random(0,lasknwnpos[i]+290)) end
            else params:set("V"..i.."_Scrll",((math.random(0,64)*lasknwnpos[i])/64)/58.0) end 
          end
          if params:get("V"..i.."_ASp")>0 then
            params:set("V"..i.."_Spd",params:get("V"..i.."_Spd")+((math.random(8)-4)*2)*0.015625) 
          end 
        elseif val<(params:get("ATr")*0.8) and params:get("Pll")>0 then params:set("Pll",0) end
  end end end
  pollr.callback = function(val) 
    for i=1,6 do
      if params:get("AT2")>0 then
        if val>params:get("ATr") and params:get("Pll")<1 then
          if params:get("V"..i.."_ARc")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              prerecz[i]=2 lpcount[i]=1 params:set("AT2",0)
            else params:set("V"..i.."_Rc",1) end
          end
          if params:get("V"..i.."_ALn")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              prerecz[i]=2 lpcount[i]=1 params:set("AT2",0)
            else params:set("V"..i.."_Len",(math.random(64)*2)*0.0078125) end
          end
          if params:get("V"..i.."_APs")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              if i<3 then softcut.position(i,math.random(0,lasknwnpos[i]+58))
              elseif i>2 and i<5 then softcut.position(i,math.random(0,lasknwnpos[i]+174))
              elseif i>4 then softcut.position(i,math.random(0,lasknwnpos[i]+290)) end
            else params:set("V"..i.."_Scrll",((math.random(0,64)*lasknwnpos[i])/64)/58.0) end 
          end
          if params:get("V"..i.."_ASp")>0 then
            params:set("V"..i.."_Spd",params:get("V"..i.."_Spd")+((math.random(8)-4)*2)*0.015625) 
          end
        elseif val<(params:get("ATr")*0.8) and params:get("Pll")>0 then params:set("Pll",0) end
  end end end
  pchlf.callback = function(val)
    if val>20 then
      for i=1,6 do if params:get("V"..i.."_PLn")>0 then params:set("V"..i.."_Lns",1.0/val) end end
      if params:get("S_PRz")>0 then 
        engine.rzset(mutil.freq_to_note_num(val),0.2,0.2) 
        engine.fxrtrz(1) engine.fxrtrv(math.random(2)-1)
      end 
    end
  end
  pchrt.callback = function(val)
    if val>20 then
      for i=1,6 do if params:get("V"..i.."_PLn")>0 then params:set("V"..i.."_Lns",1.0/val) end end
      if params:get("S_PRz")>0 then 
        engine.rzset(mutil.freq_to_note_num(val),0.2,0.2) 
        engine.fxrtrz(1) engine.fxrtrv(math.random(2)-1) 
      end 
    end
  end
  pollf.time = 0.06 pollr.time= 0.06 pchlf.time = 0.06 pchrt.time = 0.06
  engine.flow() engine.rzr(55,0.12,0.2,0,2); engine.dst(tempo,1,1,3) engine.rvrb(2,0) --route fx
  clock.run(uic)
end

function uic() 
  while true do 
    if page==2 then clock.sync(1/4) --if on sequencer page, synchronize visual to clock, otherwise...
    else clock.sleep(0.0625) end    --refresh every 1/16th of a second
    if filsel<1 and rdrw>0 then redraw() end --let 'fileselect' have its own redraw(+ only redraw if not already)
  end 
end

function epos(indx,pstn) 
  if indx<3 then lasknwnpos[indx]=(pstn-58)%58 
  elseif indx>2 and indx<5 then lasknwnpos[indx]=(pstn-174)%58 
    else lasknwnpos[indx]=(pstn-290)%58 end
end

function clock.transport.start() ply.status=1; go=1; id=clock.run(popz) end --start(k2 while swing/tempo selected)

function clock.transport.stop() ply.status=4; clock.cancel(id); go=0; id=nil end --stop(k2 while swing/tempo slctd)

function enc(n,d)                         --ENCODER--
  if n==1 then
    local pageremember=page
    page=util.wrap(page+d,1,3)        --enc1 switches pages
    if pageremember==1 and page==2 then sel = util.clamp(sel-12,0,4)
      elseif pageremember==2 and page==1 then sel = sel+12 end
  elseif n==2 then
    if page==1 then               --page1 = main page(one-shot drums played back from supercollider + timing/presets)
      sel = util.wrap(sel+d,-9,25) --enc2 scrolls parameter selection.
      if sel==-1 then ply.active=true else ply.active=false end
    elseif page==2 then
      if edit==0 then --edit mode applies to editing sequencer (-> k2 while 'vol' is hilited)
        sel = util.wrap(sel+d,-1,5) --enc2 scrolls parameter selection..or..
        if sel==-1 then ply.active=true else ply.active=false end
      else                                        --..scrolls through which step to edit in sequencer
        if sel>-1 and sel<4 then 
          sl = util.wrap(sl+d,1,(#seq[sel+1]+params:get("S"..(sel+1).."_Sln"))) 
          uipag=util.round(math.floor((sl-1)/16),1) end
      end
    elseif page==3 then
      hsel=util.wrap(hsel+d,-1,15)    --on softcut page, enc2 selects which 'v'oice
      if hsel==0 then ply.active=true else ply.active=false end
    end
  elseif n==3 then              --enc3 changes parameter values(or edits chosen step in sequencer)
    if page==1 then
      if sel==-7 then params:set("ATr",util.clamp(util.round(params:get("ATr")+(d*0.0001),0.00001),0.0,1.0))
      elseif sel==0 then
        params:set("clock_tempo",util.round(params:get("clock_tempo")+(d*0.2),0.1)) 
        tempo=params:get("clock_tempo")
      elseif sel==1 then 
        if swuiflag==1 then params:set("Swdth", util.clamp(params:get("Swdth") + (d*0.01),0.0,1.0))
        else params:set("Swng", util.clamp(params:get("Swng") + (d*0.01),0.0,2.0)) end
      elseif sel==2 then params:set("Fxvc", util.clamp(params:get("Fxvc") + d,0,128))
      elseif sel==3 then fildrsel = util.wrap(fildrsel+d,1,4)
      elseif sel>3 and sel<8 then
        params:set("S"..(sel-3).."_Svl", util.clamp(params:get("S"..(sel-3).."_Svl") + (d*0.2),0,4))
      elseif sel>7 and sel<24 then
        params:set("S"..(((sel-8)%4)+1).."_Sln", util.clamp(params:get("S"..(((sel-8)%4)+1).."_Sln") + d,-63,0))
      elseif sel==24 then
        if spr>0 then params:set("SPre",util.wrap(params:get("SPre")+d,1,500)) sprenum = params:get("SPre")
        else sprenum = util.wrap(sprenum+d,1,500) end
      elseif sel==25 then params:set("MPre",util.wrap(params:get("MPre")+d,1,500)) end
    elseif page==2 then
      if sel>-1 and sel<4 then
        if edit==1 then seq[sel+1][sl]=util.wrap(seq[sel+1][sl]+d,0,11)
        elseif fil==1 then
          selct[((sel)%4)+1] = util.clamp(selct[((sel)%4)+1]+d,1,#files[((sel)%4)+1])
          engine.flex(((sel)%4),fildir[((sel)%4)+1]..files[((sel)%4)+1][selct[((sel)%4)+1]])
        else
          params:set("S"..(((sel)%4)+1).."_Sln", util.clamp(params:get("S"..(((sel)%4)+1).."_Sln") + d,-63,0))
        end
      elseif sel==4 then uipag=util.clamp(uipag+d,0,3) 
      elseif sel==5 then fildrsel = util.wrap(fildrsel+d,1,4) end
    elseif page==3 then
      if hsel==-1 then
        if vpr>0 then params:set("VPre",util.wrap(params:get("VPre")+d,1,500)) vprenum = params:get("VPre")
        else vprenum = util.wrap(vprenum+d,1,500) end
      elseif hsel==2 then                              --hsel=2 - softcut voice(vsel)
        vsel=util.wrap(vsel+d,1,6)
      elseif hsel==4 then                            --hsel=4 - input_select
        params:set("V"..vsel.."_In",util.clamp(params:get("V"..vsel.."_In")+d,1,8))
      elseif hsel==5 then                    --hsel=5 > mode selection(stutter(1),delay(2),loop(3))
        params:set("V"..vsel.."_Mod",util.wrap(params:get("V"..vsel.."_Mod")+d,1,3))
      elseif hsel==8 then
        if params:get("V"..vsel.."_Mod")<3 then
          local vln = params:get("V"..vsel.."_Len")
          if vln>8 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+d,2,24.0),1))
          elseif vln>1 and vln<=8 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.5),0.5,24.0),0.5))
          elseif vln>0.5 and vln<=1 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.25),0.25,24.0),0.25))
          elseif vln>0.25 and vln<=0.5 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.125),0.125,24.0),0.125))
          elseif vln>0.125 and vln<=0.25 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.0625),0.0625,24.0),0.0625))
          elseif vln>0.0625 and vln<=0.125 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.03125),0.03125,24.0),0.03125))
          elseif vln>0.03125 and vln<=0.0625 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.015625),0.015625,24.0),0.015625))
          else
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.004),0.004,4.0),0.004))
          end
        else params:set("V"..vsel.."_Impatnz",util.clamp(params:get("V"..vsel.."_Impatnz")+d,0,64)) end
      elseif hsel==9 then   --hsel=8 > in "St" mode(scrolls position), in "Lp"(choose loop num), else feedback
        if params:get("V"..vsel.."_Mod")==3 then
          local maxx=math.floor(58.0/(params:get("V"..vsel.."_Bar")*(60/params:get("clock_tempo"))))
          params:set("V"..vsel.."_LpNum", util.wrap(params:get("V"..vsel.."_LpNum")+d,0,maxx))
        elseif params:get("V"..vsel.."_Mod")==1 then
          params:set("V"..vsel.."_Scrll",util.round((params:get("V"..vsel.."_Scrll")+(d*0.0002))%1.0,0.0001))
        else params:set("V"..vsel.."_Fbk",util.round(util.clamp(params:get("V"..vsel.."_Fbk")+(d*0.1),0.0,1.0),0.1)) end
      elseif hsel==10 then                             --hsel=7 > playback-speed
        params:set("V"..vsel.."_Spd",util.round(util.clamp(params:get("V"..vsel.."_Spd")+(d*0.125),-2,2),0.125))
      elseif hsel==11 then                             --hsel=8 > panning-width
        params:set("V"..vsel.."_Pn",util.round(util.clamp(params:get("V"..vsel.."_Pn")+(d*0.05),0.0,1.0),0.01))
      elseif hsel==12 then                             --hsel=9 > softcut-voice volume
        params:set("V"..vsel.."_Vol",util.round(util.clamp(params:get("V"..vsel.."_Vol")+(d*0.05),0.0,2.0),0.01))
      elseif hsel==13 then                             --hsel=10 > live-looper cycle-length
        params:set("V"..vsel.."_Bar",util.clamp(params:get("V"..vsel.."_Bar")+d,1,32))
      end
    end
  end
  if(rdrw<1) then rdrw=1 end
end

function key(n,z)
  if n==1 and z==1 then
    oone=1 onne=1
  elseif n==1 and z==0 then     
    onne=util.clamp(onne-1,0,2) oone=util.clamp(oone-1,0,2)
  elseif n==2 and z==1 then
    if onne==1 then                                               --k1 followed by k2 decrements preset..
      if page==1 then 
        params:set("SPre", util.wrap(params:get("SPre")-1,1,500)) --..(on page1)..
        sprenum=params:get("SPre")
      else                                                        --..(on page2)
        params:set("VPre", util.wrap(params:get("VPre")-1,1,500))
        vprenum=params:get("VPre")
      end onne=2
    elseif twoo==1 then                               --k3 followed by k2 toggles random echo/reverb
      keytog=1-keytog
      if keytog>0 then
        engine.dstset(math.random(1,6)*((tempo/60.)*0.03125),1) engine.fxrtrv(math.random(0,1)) 
      else engine.fxrtrv(0) end
      engine.fxrtds(keytog*2) twoo=2
    else two=1 end--k2-down followed by k3-down picks random files(main page)..
  elseif n==2 and z==0 then                  --..or changes selected voice's 'Mode'(softcut page)
    if onne==0 then
    if twoo==0 then
      if two<2 then
        if page==1 then
          if sel==24 then spwrit("S_"..sprenum..".lki") --WARNING:WITH SEQ-PAGE PRESET SELECTED K2 SAVES TO FILE!!
          elseif sel==25 then mpwrit("M_"..params:get("MPre")..".lki")--WARNING:WITH MASTR PRESET SELECTED, K2 SAVES FILE!
          end
        elseif page==2 then
          if sel==-1 then --while playbutton is selected k2 can start/stop transport with reset..
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
          elseif sel<4 then edit=1-edit --k2-up switches to edit-sequencer
          else fil=1-fil end
        else                                                        --softcut/alternate page
          if hsel==-1 then vpwrit("V_"..vprenum..".lki") --WARNING:WITH SoftCut-PAGE PRESET SELECTED, K2 SAVES FILE!
          elseif hsel==0 then
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
          elseif hsel==1 then     --..clear the buffer region if the leftmost 'V#' in the row is selected...
                if vsel<3 then softcut.buffer_clear_region_channel(vsel,0,116,0.01,0.0) 
                elseif vsel>2 and vsel<5 then softcut.buffer_clear_region_channel(vsel-2,116,232,0.01,0.0)
                else softcut.buffer_clear_region_channel(vsel-4,232,348,0.01,0.0) end
          else
            if params:get("V"..vsel.."_Mod")==1 then                              --Mode 1 = stutter
                params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))  --k2 turns stutter on/off
                if params:get("V"..vsel.."_Go")>0 then                      --clock turns rec off after 2-4beats
                params:set("V"..vsel.."_Rc",1) end
            elseif params:get("V"..vsel.."_Mod")==2 then                          --Mode 2 = Delay
              params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))   --k2 turns delay on/off
            else      --Mode 3 = Live Looper; k2 sets recording to start at beginning of next cycle...
              prerecz[vsel]=2                     --..then stop-recording and start-play at cycle after that
      end end end end
    two=util.clamp(two-1,0,2)
    else twoo=util.clamp(twoo-1,0,2) end
    else onne=util.clamp(onne-1,0,2) end
  elseif n==3 and z==1 then
    if oone==1 then                       --k1 followed by k3 increments preset..
      if page==1 then 
        params:set("SPre", util.wrap(params:get("SPre")+1,1,500)) --..(on main page)..
        sprenum=params:get("SPre")
      else                            
        params:set("VPre", util.wrap(params:get("VPre")+1,1,500)) --..(on softcut page)
        vprenum=params:get("VPre")
      end oone=2
    elseif two==1 then
      if page==1 then
        if sel==1 then  --on main page, while 'tempo' selected, k2-down then k3-down(release in same order)
          params:set("InMon", 1-params:get("InMon"))  --(un)mutes input monitor
        elseif sel>3 and sel<8 then       --otherwise, chooses random files..
          for i=1,4 do selct[i] = math.random(#files[i]) engine.flex(i-1,fildir[i]..files[i][selct[i]]) end
        elseif sel>7 and sel<12 then  --..or randomly toggles 'drunk-walk thru files' option..
          for i=1,4 do params:set("S"..i.."_Dfl", math.random(2)-1) end
        elseif sel>11 and sel<16 then  --..or randomly toggles 'random sequence length' option..
          for i=1,4 do params:set("S"..i.."_Rln", math.random(2)-1) end
        elseif sel>15 and sel<20 then  --....or randomly toggles 'random cutoff' option..
          for i=1,4 do params:set("S"..i.."_Rct", math.random(2)-1) end
        elseif sel>19 and sel<24 then  --..or randomly toggles random stutter option..
          for i=1,4 do  params:set("S"..i.."_Stt", math.random(3)-1) end  --..depends on UI selected
        elseif sel==24 then params:set("VPre", util.wrap(params:get("SPre"),1,500)) end
      else              --on alternate(softcut) page, k2-down followed by k3-down switches through modes
        params:set("V"..vsel.."_Mod",util.wrap(params:get("V"..vsel.."_Mod")+1,1,3))
      end
      two=2
    else
      if page==1 and sel==3 then filsel=1 fileselect.enter(_path.audio,callback) else twoo=1 end
      if page==2 and sel==5 then filsel=1 fileselect.enter(_path.audio,callback) else twoo=1 end
    end
  elseif n==3 and z==0 then
    if oone==0 then
    if twoo<2 then
      if two==0 then
        if page==1 then                   --on the main page, k3 toggles parameter changes(on/off style)
          if sel==-9 then params:set("AT1",1-params:get("AT1"))
          elseif sel==-8 then params:set("AT2",1-params:get("AT2"))
          elseif sel==-6 then params:set("PT1",1-params:get("PT1")) 
            if params:get("PT1")>0 then pollf:start() else pollf:stop() end
          elseif sel==-5 then params:set("PT2",1-params:get("PT2")) 
            if params:get("PT2")>0 then pollr:start() else pollr:stop() end
          elseif sel==-4 then params:set("S_PRz",1-params:get("S_PRz"))
          elseif sel==-3 then prmfreez=1-prmfreez
          elseif sel==-2 then lrn=util.wrap(lrn+1,0,2)
          elseif sel==-1 then --while playbutton is selected k3 can start/stop transport with reset..
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
          elseif sel==1 then swuiflag=util.wrap(swuiflag+1,0,2) if swuiflag==1 then swim=params:get("Swng") end
          elseif sel==2 then tix=0 tixx=-1 --while fxv selected, k3 can reset transport..
          elseif sel>3 and sel<8 then params:set("S"..(sel-3).."_Ply", 1-params:get("S"..(sel-3).."_Ply"))
          elseif sel>7 and sel<12 then params:set("S"..(sel-7).."_Dfl", 1-params:get("S"..(sel-7).."_Dfl"))
          elseif sel>11 and sel<16 then params:set("S"..(sel-11).."_Rln", 1-params:get("S"..(sel-11).."_Rln"))
          elseif sel>15 and sel<20 then params:set("S"..(sel-15).."_Rct", 1-params:get("S"..(sel-15).."_Rct"))
          elseif sel>19 and sel<24 then params:set("S"..(sel-19).."_Stt", util.wrap(params:get("S"..(sel-19).."_Stt")+1,0,2))
            if params:get("S"..(sel-19).."_Stt")==0 then pause[sel-19]=0 end
          elseif sel==24 then
            spr=1-spr if spr>0 then params:set("SPre",sprenum) end --with preset selected k3 will toggle preset-'activate'
          else params:set("Fxv", 1-params:get("Fxv")) end
        elseif page==2 then
          if sel==-1 then
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
          elseif sel==0 then params:set("S"..(sel+1).."_Ply", 1-params:get("S"..(sel+1).."_Ply"))
          elseif sel==1 then params:set("S"..(sel+1).."_Ply", 1-params:get("S"..(sel+1).."_Ply"))
          elseif sel==2 then params:set("S"..(sel+1).."_Ply", 1-params:get("S"..(sel+1).."_Ply"))
          elseif sel==3 then params:set("S"..(sel+1).."_Ply", 1-params:get("S"..(sel+1).."_Ply"))
          elseif sel>3 then for y=1,4 do params:set("S"..y.."_Ply", math.random(0,1)) end end
        else                    --on the alternate(softcut) page, k3 can..
          if hsel==-1 then 
            vpr=1-vpr if vpr>0 then params:set("VPre",vprenum) end  --toggle preset-'activate'..
          elseif hsel==0 then 
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
          elseif hsel==2 then pfreez[vsel]=1-pfreez[vsel] --..freeze params so the next preset doesn't load this row..
          elseif hsel==3 then --..or toggle playback for the softcut voice(s) if the "-/>" in each row is selected..
            if params:get("V"..vsel.."_Mod")==3 then lplay[vsel]=1-lplay[vsel] softcut.play(vsel,lplay[vsel])
              else params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go")) end
          elseif hsel==6 then
            params:set("V"..vsel.."_ALn",1-params:get("V"..vsel.."_ALn"))
          elseif hsel==7 then
            params:set("V"..vsel.."_PLn",1-params:get("V"..vsel.."_PLn"))
          elseif hsel==9 then
            params:set("V"..vsel.."_APs",1-params:get("V"..vsel.."_APs"))
          elseif hsel==10 then
            params:set("V"..vsel.."_ASp",1-params:get("V"..vsel.."_ASp"))
          elseif hsel==14 then
            params:set("V"..vsel.."_ARc",1-params:get("V"..vsel.."_ARc"))
          elseif hsel==15 then 
                poslfoz[vsel]:set('max', util.round(lasknwnpos[vsel]/58.0,0.0001))
                plf[vsel]=util.wrap(plf[vsel]+1,0,3) poslfoz[vsel]:set('depth', 1.0)
                if plf[vsel] == 0 then poslfoz[vsel]:stop()
                elseif plf[vsel] == 1 then poslfoz[vsel]:set('shape', 'random') lfprmult=0.25 poslfoz[vsel]:start()  
                elseif plf[vsel] == 2 then poslfoz[vsel]:set('shape', 'saw') lfprmult=0.75 poslfoz[vsel]:start()
                elseif plf[vsel] == 3 then poslfoz[vsel]:set('shape', 'sine') lfprmult=0.5 poslfoz[vsel]:start() end
          else 
              if params:get("V"..vsel.."_Mod")==1 and hsel==8 then 
                lasknwnpos[vsel] = (params:get("V"..vsel.."_Scrll") * 58.0) end
        end end
      else two=util.clamp(two-1,0,2) end
    end
    twoo=util.clamp(twoo-1,0,2)
    else oone=util.clamp(oone-1,0,2) end
  end
  if(rdrw<1) then rdrw=1 end
end

function callback(file_path)              --when 'fileselect' returns, process directory accordingly
  fildir[fildrsel]=_path.audio..string.sub(file_path,21,string.match(file_path, "^.*()/")) --store dirs
  files[fildrsel]=util.scandir(fildir[fildrsel]) filsel=0 --load names of files in dir to file-table/vox
end

function stutz(num,typ,tp)  --clocked function for different kind of stutter applied on oneshot/eng trigs
  local ranfreq1 = math.random(500,6500) local ranfreq2 = math.random(5000)+2800.0 
  local ranspd = math.random(-50,50)*0.002+1.0
  local geom local rdr=((math.random(2)-1)*2)-1 local rndy=math.random(3) local tmp=math.random(3)
  local vl,rct rct=params:get("S"..typ.."_Rct") vl=params:get("S"..typ.."_Svl") 
  local enginstuts = {
    function() engine.awyea1(0.0,ranspd,vl,ranfreq1+((1-rct)*8388),0.25) end,
    function() engine.awyea2(math.random(-10,10)*0.01,ranspd,vl, ranfreq1+((1-rct)*8388),0.25) end,
    function() engine.awyea3(math.random(-50,50)*0.02,ranspd,vl, ranfreq2+((1-rct)*6088),0.25) end,
    function() engine.awyea4(math.random(-50,50)*0.02,ranspd,vl, ranfreq1+((1-rct)*8388),0.25) end}
  if rdr>0 then geom=0 else geom=num end 
  for i=1,num do
    if tp==2 then
      if num>6 then--if incoming 'num' is greater than 8 do a 'geometric series' style of stutter(accelerando/deccelerando)..
        if rndy==3 then clock.sleep(math.pow(((1/tmp)*15)/tempo,0.09375*i)+0.02)
          elseif rndy==2 then clock.sleep(math.pow(((1/tmp)*15)/tempo,0.09375*(num-(i-1)))+0.01)
          else clock.sleep(1/((num+1)/((num+1)-geom))+0.02) end             
        enginstuts[typ]() geom=geom+(rdr*(1/math.random(4))) 
      else clock.sync(1/(num+2)) enginstuts[typ]() end --..otherwise do a regular stutter
    elseif tp==1 then clock.sync(1/(num+2)) enginstuts[typ]() end --regular stutters only
    if i==num then pause[typ]=0 end
  end
end

function vstutz(rp,vc,rndy,tmp,num) --a clocked function for yet another kind of stutter applied on the softcut/looper voices
  for i=1,(num+1) do
    if i>num then vpause[vc]=0 
    else
      if num>10 then     --if incoming 'num'>10 do 'geometric series' style of stutter(accel/deccel)..
        if rndy==2 then clock.sleep(math.pow(((1/tmp)*15)/tempo,(1/math.random(4,8))*i)+0.02)
        else clock.sleep(math.pow(((1/tmp)*15)/tempo,(1/math.random(4,8))*(num-(i-1)))+0.02) end  
        softcut.position(vc,rp+(math.random(100)*0.0098)) 
      elseif num>4 and num<11 then                          --..otherwise do a regular stutter
        clock.sync(1/num)             softcut.position(vc,rp+(math.random(10)*0.02)) 
      else softcut.position(vc,rp) end                      --..or straight cut
      print(rp)
    end
  end
end

function enginstep(vc,rp,sp)     --vc=voice, rp=repeats
  local ranfreq1=math.random(500,6500) local ranfreq2=math.random(5000)+2800.0 
  local rct=params:get("S"..vc.."_Rct") local vl=params:get("S"..vc.."_Svl") 
  local engins = {        --engine.awyea#(pan, speed, gain, cutoff-freq, release-time(sec))
    function() engine.awyea1(0.0,sp,vl, ranfreq1+((1-rct)*8388),1.0) end,    --no panning for kick drums
    function() engine.awyea2(math.random(-10,10)*0.01,sp,vl, ranfreq1+((1-rct)*8388),1.0) end,
    function() engine.awyea3(math.random(-50,50)*0.02,sp,vl, ranfreq2+((1-rct)*6088),1.0) end,--different freq 4 hi-hats
    function() engine.awyea4(math.random(-50,50)*0.02,sp,vl, ranfreq1+((1-rct)*8388),1.0) end}
  engins[vc]() 
  if rp>1 and rp<5 then for i=1,(rp-1) do clock.sync(1/(4*rp)) engins[vc]() end
  elseif rp>4 and rp<8 then 
    rp=math.random(1,5)+((rp-4)*2); for i=1,rp do clock.sync(1/(4*rp)) engins[vc]() end
  elseif rp>7 then 
    rp=math.random(0,1)+(rp-7); for i=1,(rp-1) do clock.sync(1/(4*rp)) engins[vc]() end
  end
end

function popz()         --main triggering clock function
  while true do
    clock.sync(1/4,((1/4)*params:get("Swng"))*swflag)
    for i=1,4 do                                          --beginning of code for one-shotz sequencer
      if params:get("S"..i.."_Ply")>0 then
        local tp=params:get("S"..i.."_Stt") local sln=params:get("S"..i.."_Sln")
        local nt=seq[i][(tix%(#seq[i]+sln))+1]
        if pause[i]<1 then
          if nt>0 then
            local ranspd=(math.random(-50,50)*0.002+1.0)
            if nt>7 then ranspd = ranspd * -2.8 end
            clock.run(enginstep,i,nt,ranspd) 
            if tp==2 then 
              if math.random(4)>3 then local rnm=math.random(16) pause[i]=1 clock.run(stutz,rnm,i,2) end
            elseif tp==1 then 
              if math.random(4)>3 then local rnm=math.random(12) pause[i]=1 clock.run(stutz,rnm,i,1) end end
            if params:get("S"..i.."_Dfl")>0 then 
              if math.random(2)>1 then 
                selct[i] = util.clamp(selct[i]+((math.random(0,1)*2)-1),1,#files[i])
                engine.flex(i-1,fildir[i]..files[i][selct[i]])
          end end end
          if params:get("S"..i.."_Rln")>0 then 
            if math.random(2)>1 then params:set("S"..i.."_Sln", math.random(63)*-1) end end
    end end end                                --ending of code for one-shotz sequencer
    if ((tix%4)==0) then          --random-clocked-changes to the 'FX Vortex'('fxv')
      local fxvt = params:get("Fxvc")  
      if fxvt>0 then
        if (tixx%fxvt)==0 then
          if params:get("Fxv")>0 then
            local chs=math.random(1,3); if math.random(2)>1 then keytog=1-keytog end
            if chs==1 then
              engine.dstset(math.random(1,6)*((tempo/60.)*0.03125),1) engine.fxrtds(keytog)
            elseif chs==2 then engine.rzset(rezpitchz[math.random(20)],0.22,0.28); engine.fxrtrz(keytog)
            elseif chs==3 then engine.fxrtrv(keytog) end
      end end end
      tixx = tixx + 1 --tixx = 1/4 note
      for i=1,6 do  --automated control over recording/playback progression of live-looper(or over punch in/out of delay)
        if poslfoz[i]:get('enabled') == 1 then if math.random(2)>1 then poslfoz[i]:set('period', math.random(16)*lfprmult) end end
        if params:get("V"..i.."_Mod")==3 then                          --if in looper mode..
          if (tixx%params:get("V"..i.."_Bar")) == 0 then  --the 'Cyc'('Bar') param is how many beats-per-bar to capture of loop
            if prerecz[i] == 2 then params:set("V"..i.."_Rc",1) end   --..count off progression towards loop-capture..
            if params:get("V"..i.."_Rc")>0 then 
              if prerecz[i]>1 then prerecz[i]=prerecz[i]-1          --..finish recording..
              else                                                  
                prerecz[i]=prerecz[i]-1                           --..then stop rec and start play..
                params:set("V"..i.."_Rc",0) params:set("V"..i.."_Go",0) params:set("V"..i.."_Go",1) 
              end
            else 
              if params:get("V"..i.."_Impatnz")>0 then lpcount[i]=lpcount[i]+1 end   --..if playing, countoff 'impatienz'
              if lplay[i]>0 then params:set("V"..i.."_Go",0) params:set("V"..i.."_Go",1) end --restart each new bar
            end
          end
        elseif params:get("V"..i.."_Mod")==2 and params:get("V"..i.."_Go")>0 then   -- elseif in delay mode..
          params:set("V"..i.."_Rc",util.clamp(math.random(5)-2,0,1)) --random chance of 2/5 that delay turns off every bar
        end 
      end
    end
    for i=1,6 do                                     --outside of quarternotes, do this every 16th:
      local brsc = params:get("V"..i.."_Bar")*(60/params:get("clock_tempo"))
      local lpsc = brsc * params:get("V"..i.."_LpNum")
      local ps=58+lpsc if i<3 then ps=ps elseif i>2 and i<5 then ps=174+lpsc else ps=290+lpsc end 
      if params:get("V"..i.."_Go")>0 then 
        softcut.pan(i,(math.random(-50,50)*0.02)*params:get("V"..i.."_Pn"))  --apply random panning
        if params:get("V"..i.."_Mod")==3 then                                       --if in looper mode..
          if params:get("V"..i.."_Rc")==0 and params:get("V"..i.."_Impatnz")>0  
            and lpcount[i]>params:get("V"..i.."_Impatnz") and lplay[i]>0 and vpause[i]<1 then    
            local rn=math.random(0,params:get("V"..i.."_Bar")-1) local rp=ps+(rn*(60/tempo)) --..and 'impatient'..
            local rndy=math.random(2) local tmp=math.random(4)+1 local num=math.random(24) vpause[i]=1
            clock.run(vstutz,rp,i,rndy,tmp,num) --..improvise automated/randomized playback/stuttering 
    end end end end
    if swuiflag==2 then --if selected to, random-walk 'swing' within range of 'swing width(swidth)'
      local swdth=params:get("Swdth")
      params:set("Swng",util.clamp(params:get("Swng")+(math.random(-5,5)*0.01),swim-swdth,swim+swdth)) 
    end
    swflag = 1-swflag tix=tix+1 if (rdrw<1) then rdrw=1 end --tix = 1/16th note
  end
end

function cleanup() engine.darknez() end
