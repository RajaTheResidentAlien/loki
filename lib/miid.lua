--Master preset stuff(MIDI Program Changes)

function mpwrit(nam)                                 --Master preset write
  local mwritab={} mwritab["SPre"]=params:get("SPre") mwritab["VPre"]=params:get("VPre") 
  mwritab["SPrePgChD"]=params:get("SPrePgChD") mwritab["SPrePgChU"]=params:get("SPrePgChU")
  mwritab["SPreActivePgCh"]=params:get("SPreActivePgCh") mwritab["VPrePgChD"]=params:get("VPrePgChD")
  mwritab["VPrePgChU"]=params:get("VPrePgChU") mwritab["VPreActivePgCh"]=params:get("VPreActivePgCh")
  mwritab["InputPgCh"]=params:get("InputPgCh") mwritab["FreezePgCh"]=params:get("FreezePgCh")
  mwritab["UIGoPgCh"]=params:get("UIGoPgCh") mwritab["PlayPgCh"]=params:get("PlayPgCh") 
  mwritab["RestartPgCh"]=params:get("RestartPgCh") mwritab["DelRevPgCh"]=params:get("DelRevPgCh")
  mwritab["FXVPgCh"]=params:get("FXVPgCh") mwritab["PtchPLPgCh"]=params:get("PtchPLPgCh") 
  mwritab["PtchPRPgCh"]=params:get("PtchPRPgCh") mwritab["PtchPRzPgCh"]=params:get("PtchPRzPgCh")
  for i=1,6 do
    mwritab["V"..i.."PreFreezePgCh"]=params:get("V"..i.."PreFreezePgCh") 
    mwritab["V"..i.."K2PgCh"]=params:get("V"..i.."K2PgCh")
    mwritab["V"..i.."K3PgCh"]=params:get("V"..i.."K3PgCh")
    mwritab["V"..i.."LFOPgCh"]=params:get("V"..i.."LFOPgCh")
    mwritab["V"..i.."Amp2LnPgCh"]=params:get("V"..i.."Amp2LnPgCh")
    mwritab["V"..i.."Ptch2LnPgCh"]=params:get("V"..i.."Ptch2LnPgCh")
    mwritab["V"..i.."Amp2PosPgCh"]=params:get("V"..i.."Amp2PosPgCh")
    mwritab["V"..i.."Amp2SpdPgCh"]=params:get("V"..i.."Amp2SpdPgCh")
    mwritab["V"..i.."AmpLOnPgCh"]=params:get("V"..i.."AmpLOnPgCh")
    mwritab["V"..i.."AmpROnPgCh"]=params:get("V"..i.."AmpROnPgCh")
    mwritab["V"..i.."AmpRecPgCh"]=params:get("V"..i.."AmpRecPgCh")
  end
  tab.save(mwritab,_path.data.."loki/"..nam)
end

function mpread(nam)                                  --Master preset read
  local err local mreadtab={} mreadtab,err=tab.load(_path.data.."loki/"..nam)
  if err==nil then
      params:set("SPre", mreadtab["SPre"]) params:set("VPre", mreadtab["VPre"])
      params:set("SPrePgChD",mreadtab["SPrePgChD"]) params:set("SPrePgChU",mreadtab["SPrePgChU"]) 
      params:set("SPreActivePgCh",mreadtab["SPreActivePgCh"]) params:set("VPrePgChD",mreadtab["VPrePgChD"]) 
      params:set("VPrePgChU",mreadtab["VPrePgChU"]) params:set("VPreActivePgCh",mreadtab["VPreActivePgCh"])
      params:set("InputPgCh", mreadtab["InputPgCh"]) params:set("FreezePgCh", mreadtab["FreezePgCh"]) 
      params:set("UIGoPgCh", mreadtab["UIGoPgCh"]) params:set("PlayPgCh", mreadtab["PlayPgCh"])
      params:set("RestartPgCh", mreadtab["RestartPgCh"]) params:set("DelRevPgCh", mreadtab["DelRevPgCh"])
      params:set("FXVPgCh", mreadtab["FXVPgCh"]) params:set("PtchPLPgCh", mreadtab["PtchPLPgCh"])
      params:set("PtchPRPgCh", mreadtab["PtchPRPgCh"]) params:set("PtchPRzPgCh", mreadtab["PtchPRzPgCh"])
    for i=1,6 do 
      params:set("V"..i.."PreFreezePgCh", mreadtab["V"..i.."PreFreezePgCh"]) 
      params:set("V"..i.."K2PgCh", mreadtab["V"..i.."K2PgCh"])
      params:set("V"..i.."K3PgCh", mreadtab["V"..i.."K3PgCh"])
      params:set("V"..i.."LFOPgCh", mreadtab["V"..i.."LFOPgCh"])
      params:set("V"..i.."Amp2LnPgCh", mreadtab["V"..i.."Amp2LnPgCh"])
      params:set("V"..i.."Ptch2LnPgCh", mreadtab["V"..i.."Ptch2LnPgCh"])
      params:set("V"..i.."Amp2PosPgCh", mreadtab["V"..i.."Amp2PosPgCh"])
      params:set("V"..i.."Amp2SpdPgCh", mreadtab["V"..i.."Amp2SpdPgCh"])
      params:set("V"..i.."AmpLOnPgCh", mreadtab["V"..i.."AmpLOnPgCh"])
      params:set("V"..i.."AmpROnPgCh", mreadtab["V"..i.."AmpROnPgCh"])
      params:set("V"..i.."AmpRecPgCh", mreadtab["V"..i.."AmpRecPgCh"])
    end
  end
end
params:add_number("MPre", "MasterPreset",1,500,1)
params:set_action("MPre", function(mpre) mpread("M_"..mpre..".lki") end)
params:add_number("SPre", "SPreset",1,500,1)
params:set_action("SPre", function(spre) spread("S_"..spre..".lki") end)
params:add_number("VPre", "VPreset",1,500,1)
params:set_action("VPre", function(vpre) vpread("V_"..vpre..".lki") end)
params:add_group("PgCh_Grp","ProgramChange_Group",82)
params:add_number("SPrePgChD", "SPreProgramChangeDown", 0, 127, 10)
params:add_number("SPrePgChU", "SPreProgramChangeUp", 0, 127, 11)
params:add_number("SPreActivePgCh", "SPreActiveProgramChange", 0, 127, 15)  --make S-page program changes active
params:add_number("VPrePgChD", "VPreProgramChangeDown", 0, 127, 20)
params:add_number("VPrePgChU", "VPreProgramChangeUp", 0, 127, 21)
params:add_number("VPreActivePgCh", "VPreActiveProgramChange", 0, 127, 17)  --make V-page program changes active
params:add_number("InputPgCh", "InputMonitorProgramChange", 0, 127, 18)
params:add_number("FreezePgCh", "FreezeProgramChange", 0, 127, 19)          --freeze tempo-related params
params:add_number("UIGoPgCh", "UIGoProgramChange", 0, 127, 16)
params:add_number("PlayPgCh", "PlayProgramChange", 0, 127, 14)              --toggle play on/off
params:add_number("RestartPgCh", "RestartProgramChange", 0, 127, 30)        --restart transport(w/out off)
params:add_number("DelRevPgCh", "DelayReverbProgramChange", 0, 127, 4)      --toggle random delay/reverb
params:add_number("FXVPgCh", "FXVortexProgramChange", 0, 127, 5)            --toggle FX Vortex on/off
params:add_number("PtchPLPgCh", "PitchPollLeftProgramChange", 0, 127, 6)
params:add_number("PtchPRPgCh", "PitchPollRightProgramChange", 0, 127, 7)
params:add_number("PtchPRzPgCh", "PitchPollRezProgramChange", 0, 127, 8)
for i=1,6 do 
  params:add_number("V"..i.."PreFreezePgCh", "V"..i.."PreFreezeProgramChange", 0, 127, (10*i)+29)
  params:add_number("V"..i.."K2PgCh", "V"..i.."K2ProgramChange", 0, 127, (10*i)+30)
  params:add_number("V"..i.."K3PgCh", "V"..i.."K3ProgramChange", 0, 127, (10*i)+31)
  params:add_number("V"..i.."LFOPgCh", "V"..i.."LFOProgramChange", 0, 127, (10*i)+32)
  params:add_number("V"..i.."Amp2LnPgCh", "V"..i.."Amp2LengthProgramChange", 0, 127, (10*i)+33)
  params:add_number("V"..i.."Ptch2LnPgCh", "V"..i.."Pitch2LengthProgramChange", 0, 127, (10*i)+34)
  params:add_number("V"..i.."Amp2PosPgCh", "V"..i.."Amp2PositionProgramChange", 0, 127, (10*i)+35)
  params:add_number("V"..i.."Amp2SpdPgCh", "V"..i.."Amp2SpeedProgramChange", 0, 127, (10*i)+36)
  params:add_number("V"..i.."AmpLOnPgCh", "V"..i.."AmpPollLeftNoffProgramChange", 0, 127, (10*i)+37)
  params:add_number("V"..i.."AmpROnPgCh", "V"..i.."AmpPollRightNoffProgramChange", 0, 127, (10*i)+38)
  params:add_number("V"..i.."AmpRecPgCh", "V"..i.."Amp2RecProgramChange", 0, 127, (10*i)+39)
end
params:bang()   --other params exist in other files, but are instantiated first, bang here at the end

--MIDI stuff

m=midi.connect()
m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "program_change" then
    if lrn>0 then            --MIDI-learn of program change
      if page>0 then
        if sel==25 then if lrn==2 then params:set("SPrePgChU",d.val) else params:set("SPrePgChD",d.val) end
        elseif sel==24 then params:set("UIGoPgCh",d.val)      --while seq page number is selected
        elseif sel==3 then params:set("RestartPgCh",d.val)    --while file directory field is selected
        elseif sel==2 then params:set("FXVPgCh",d.val)
        elseif sel==1 then params:set("PlayPgCh",d.val)       --while tempo is selected
        elseif sel==0 then params:set("InputPgCh",d.val)      --while swing is selected
        elseif sel==-1 then params:set("DelRevPgCh",d.val)    --while midi-learn is selected
        elseif sel==-2 then params:set("FreezePgCh",d.val)
        elseif sel==-3 then params:set("PtchPLPgCh",d.val)
        elseif sel==-4 then params:set("PtchPRPgCh",d.val)
        elseif sel==-5 then params:set("PtchPRzPgCh",d.val)
        end
      else
        if vsel==0 then if lrn==2 then params:set("VPrePgChU",d.val) else params:set("VPrePgChD",d.val) end 
        else
          if hsel==-1 then params:set("V"..vsel.."PreFreezePgCh",d.val) 
          elseif hsel==0 then params:set("V"..vsel.."K2PgCh",d.val) 
          elseif hsel==1 then params:set("V"..vsel.."K3PgCh",d.val) 
          elseif hsel==2 then params:set("V"..vsel.."LFOPgCh",d.val)
          elseif hsel==5 then params:set("V"..vsel.."Amp2LnPgCh",d.val)
          elseif hsel==7 then params:set("V"..vsel.."Ptch2LnPgCh",d.val)
          elseif hsel==8 then params:set("V"..vsel.."Amp2PosPgCh",d.val)
          elseif hsel==10 then params:set("V"..vsel.."Amp2SpdPgCh",d.val)
          elseif hsel==15 then params:set("V"..vsel.."AmpLOnPgCh",d.val)
          elseif hsel==16 then params:set("V"..vsel.."AmpROnPgCh",d.val)
          elseif hsel==17 then params:set("V"..vsel.."AmpRecPgCh",d.val)
          end
        end
      end
    else                     --ProgramChange assignments/functions
      for i=1,6 do  --softcut page (used more often, so checking these 1st might be slightly faster)
        if d.val == params:get("V"..i.."PreFreezePgCh") then pfreez[i]=1-pfreez[i]
        elseif d.val == params:get("V"..i.."K2PgCh") then
          if params:get("V"..i.."_Mod")==1 then              --Mode 1 = stutter(k2 turns stutter on/off)
            params:set("V"..i.."_Go",1-params:get("V"..i.."_Go"))  --clock turns rec off after 2-4beats
            if params:get("V"..i.."_Go")>0 then params:set("V"..i.."_Rc",1) end
          elseif params:get("V"..i.."_Mod")==2 then                          --Mode 2 = Delay
            params:set("V"..i.."_Go",1-params:get("V"..i.."_Go"))   --k2 turns delay on/off
          else      --Mode 3 = Live Looper; k2 sets recording to start at beginning of next cycle...
            prerecz[i]=2                     --..then stop-recording and start-play at cycle after that
          end
        elseif d.val == params:get("V"..i.."K3PgCh") then
          if params:get("V"..i.."_Mod")==3 then lplay[i]=1-lplay[i] softcut.play(i,lplay[i])
           else params:set("V"..i.."_Go",1-params:get("V"..i.."_Go")) end
        elseif d.val == params:get("V"..i.."LFOPgCh") then
          poslfoz[i]:set('max', util.round(lasknwnpos[i]/58.0,0.0001))
          plf[i]=util.wrap(plf[i]+1,0,3) poslfoz[i]:set('depth', 1.0)
          if plf[i] == 0 then poslfoz[i]:stop()
          elseif plf[i] == 1 then poslfoz[i]:set('shape', 'random') lfprmult=0.25 poslfoz[i]:start()  
          elseif plf[i] == 2 then poslfoz[i]:set('shape', 'saw') lfprmult=0.75 poslfoz[i]:start()
          elseif plf[i] == 3 then poslfoz[i]:set('shape', 'sine') lfprmult=0.5 poslfoz[i]:start() end
        elseif d.val == params:get("V"..i.."Amp2LnPgCh") then
          params:set("V"..i.."_ALn",1-params:get("V"..i.."_ALn"))
        elseif d.val == params:get("V"..i.."Ptch2LnPgCh") then
          params:set("V"..i.."_PLn",1-params:get("V"..i.."_PLn"))
        elseif d.val == params:get("V"..i.."Amp2PosPgCh") then
          params:set("V"..i.."_APs",1-params:get("V"..i.."_APs"))
        elseif d.val == params:get("V"..i.."Amp2SpdPgCh") then
          params:set("V"..i.."_ASp",1-params:get("V"..i.."_ASp"))
        elseif d.val == params:get("V"..i.."AmpLOnPgCh") then
          params:set("V"..i.."_AT1",1-params:get("V"..i.."_AT1"))
        elseif d.val == params:get("V"..i.."AmpROnPgCh") then
          params:set("V"..i.."_AT2",1-params:get("V"..i.."_AT2"))
        elseif d.val == params:get("V"..i.."AmpRecPgCh") then
          params:set("V"..i.."_ARc",1-params:get("V"..i.."_ARc"))
        end
      end
                                                          --main page
      if d.val == params:get("SPrePgChD") then
        if spr>0 then params:set("SPre", util.wrap(params:get("SPre")-1,1,500)) sprenum = params:get("SPre")
          else sprenum = util.wrap(sprenum-1,1,500) end
      elseif d.val == params:get("SPrePgChU") then
        if spr>0 then params:set("SPre", util.wrap(params:get("SPre")+1,1,500)) sprenum = params:get("SPre")
          else sprenum = util.wrap(sprenum+1,1,500) end
      elseif d.val == params:get("SPreActivePgCh") then spr=1-spr if spr>0 then params:set("SPre",sprenum) end
      elseif d.val == params:get("VPrePgChD") then
        if vpr>0 then params:set("VPre", util.wrap(params:get("VPre")-1,1,500)) vprenum = params:get("VPre")
          else vprenum = util.wrap(vprenum-1,1,500) end
      elseif d.val == params:get("VPrePgChU") then
        if vpr>0 then params:set("VPre", util.wrap(params:get("VPre")+1,1,500)) vprenum = params:get("VPre")
          else vprenum = util.wrap(vprenum+1,1,500) end
      elseif d.val == params:get("VPreActivePgCh") then vpr=1-vpr if vpr>0 then params:set("VPre",vprenum) end
      elseif d.val == params:get("InputPgCh") then params:set("InMon", 1-params:get("InMon"))
      elseif d.val == params:get("FreezePgCh") then prmfreez=1-prmfreez
      elseif d.val == params:get("UIGoPgCh") then uigo=1-uigo
      elseif d.val == params:get("RestartPgCh") then tix=0 tixx=-1
      elseif d.val == params:get("FXVPgCh") then params:set("Fxv", 1-params:get("Fxv"))
      elseif d.val == params:get("PlayPgCh") then
        if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
            if go>0 then clock.transport.stop() else clock.transport.start() end end tix=0 tixx=-1
      elseif d.val == params:get("PtchPLPgCh") then params:set("PT1",1-params:get("PT1")) 
      elseif d.val == params:get("PtchPRPgCh") then params:set("PT2",1-params:get("PT2")) 
      elseif d.val == params:get("PtchPRzPgCh") then params:set("S_PRz",1-params:get("S_PRz"))
      end
    end
  end
end