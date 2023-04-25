Voic = {}

function Voic:new(num)
  local v = setmetatable({}, { __index = Voic })
  v.num=num  v.mde=1 v.bar=8
  softcut.enable(num,1) softcut.buffer(num,((num-1)%2)+1) softcut.loop(num,1)     --setup softcut
  softcut.rec_level(num,1.0)  softcut.level(num,1.0) softcut.rate(num,1.0) softcut.pan(num,(num%2)*2-1) 
  softcut.level_input_cut(((num-1)%2+1),num,1.0) softcut.fade_time(num,0.004) softcut.pan_slew_time(num,0.1)
  softcut.rate_slew_time(num,0.01) softcut.level_slew_time(num,0.01) softcut.recpre_slew_time(num,0.01)
  return v
end
-- Da PFunk (Parameter-based functions *nerd-face*)
function Voic:mode(mde)
  local lpstart,lenth; lpcount[self.num]=0 lenth=(60.0/(params:get("clock_tempo")/self.num)*params:get("V"..self.num.."_Len"))
  self.mde = mde
  if mde==3 then
    softcut.rec(self.num,0) softcut.loop(self.num,0)
    if self.num<3 then softcut.loop_start(self.num,58.0) softcut.position(self.num,58.0) softcut.loop_end(self.num,116.0)
    elseif self.num>2 and self.num<5 then 
      softcut.loop_start(self.num,174.0) softcut.position(self.num,174.0) softcut.loop_end(self.num,232.0)
    else softcut.loop_start(self.num,290.0) softcut.position(self.num,290.0) softcut.loop_end(self.num,348.0) end
  else
    softcut.rec(self.num,mde-1) softcut.loop(self.num,1) 
    if mde==1 then softcut.pre_level(self.num,0.0) 
      else softcut.pre_level(self.num,params:get("V"..self.num.."_Fbk")) end
    if self.num<3 then 
      if mde==2 then lpstart = 0.0 
      else lpstart = 58.0+(params:get("V"..self.num.."_Scrll")*58.0) end
    elseif self.num>2 and self.num<5 then 
      if mde==2 then lpstart=116.0 
      else lpstart = 174.0+(params:get("V"..self.num.."_Scrll")*58.0) end
    else 
      if mde==2 then lpstart=232.0 
      else lpstart = 290.0+(params:get("V"..self.num.."_Scrll")*58.0) end 
    end
    softcut.loop_start(self.num,lpstart) softcut.position(self.num,lpstart) softcut.loop_end(self.num,lpstart+lenth)
    end
    params:set("V"..self.num.."_Go",util.wrap(mde,1,2)-1)
end

function Voic:go(ply)
  if self.mde==3 then
    local barsecs = params:get("V"..self.num.."_Bar")*(60/params:get("clock_tempo"))
    local loopscs = barsecs * params:get("V"..self.num.."_LpNum")
      if self.num>4 then softcut.position(self.num,290 + loopscs) 
      elseif self.num>2 and self.num<5 then softcut.position(self.num,174 + loopscs)
      else softcut.position(self.num,58 + loopscs) end
  elseif self.mde==1 then
    local lpstart
    if self.num<3 then lpstart = 58.0+(params:get("V"..self.num.."_Scrll")*58.0)
      elseif self.num>2 and self.num<5 then lpstart = 174.0+(params:get("V"..self.num.."_Scrll")*58.0)
      else lpstart = 290.0+(params:get("V"..self.num.."_Scrll")*58.0) end    softcut.position(self.num,lpstart)
  else 
    if self.num>4 then softcut.position(self.num,232) 
      elseif self.num>2 and self.num<5 then softcut.position(self.num,116) else softcut.position(self.num,0) end
  end
  softcut.play(self.num,ply)
end

function Voic:rec(rec)
  if self.mde==3 then
    if rec>0 then 
      params:set("Pll",1)
      if self.num>4 then softcut.position(self.num,290) 
        elseif self.num>2 and self.num<5 then softcut.position(self.num,174) else softcut.position(self.num,58) end
      lpcount[self.num]=rec softcut.rec(self.num,rec) softcut.rec_level(self.num,rec)
    else softcut.query_position(self.num) softcut.rec_level(self.num,rec) softcut.rec(self.num,rec) end
  elseif self.mde==1 then 
    local skrll = lasknwnpos[self.num] local lenth=math.random(4)*0.25 
    if rec>0 then
      lasknwnpos[self.num]=util.wrap(lasknwnpos[self.num]+lenth,0.0,58.0) params:set("Pll",1)
      if self.num>4 then 
        softcut.position(self.num,290.0+skrll) softcut.loop_start(self.num,290.0+skrll) softcut.loop_end(self.num,290.0+skrll+lenth)
      elseif self.num>2 and self.num<5 then 
        softcut.position(self.num,174.0+skrll) softcut.loop_start(self.num,174.0+skrll) softcut.loop_end(self.num,174.0+skrll+lenth)
      else 
        softcut.position(self.num,58.0+skrll) softcut.loop_start(self.num,58.0+skrll) softcut.loop_end(self.num,58.0+skrll+lenth)
      end
      softcut.rec(self.num,1) softcut.rec_level(self.num,1) clock.run(recstut,lenth,self.num)
    else softcut.rec_level(self.num,rec) softcut.rec(self.num,rec) end
  else if rec>0 then params:set("Pll",1) softcut.rec(self.num,1) end softcut.rec_level(self.num,rec) end
end

function Voic:length(lnth)
  local skrll = params:get("V"..self.num.."_Scrll")
  local tmp = 60.0/(params:get("clock_tempo")/self.num) local offst
  if self.mde==2 then
    if self.num>2 and self.num<5 then offst=116 elseif self.num>4 then offst=232 else offst=0 end
  elseif self.mde==1 then
    if self.num<3 then offst=58.0+(skrll*58.0) elseif self.num>2 and self.num<5 then offst=174.0+(skrll*58.0)
      else offst = 290.0+(skrll*58.0) end
  end
  softcut.loop_start(self.num,offst) softcut.loop_end(self.num,(tmp*lnth)+offst)
end

function Voic:lninsec(lnth)
  local offst local skrll = params:get("V"..self.num.."_Scrll")
  if self.mde==2 then
    if self.num>2 and self.num<5 then offst=116 elseif self.num>4 then offst=232 else offst=0 end
  elseif self.mde==1 then
    if self.num<3 then offst = 58.0+(skrll*58.0) elseif self.num>2 and self.num<5 then offst = 174.0+(skrll*58.0)
      else offst = 290.0+(skrll*58.0) end
  end
  softcut.loop_start(self.num,offst)  softcut.loop_end(self.num,lnth+offst)
end

function Voic:scroll(scrll)
  if self.mde==1 then
    local lpstart,lenth; lenth=(60.0/(params:get("clock_tempo")/self.num)*params:get("V"..self.num.."_Len"))
    if self.num<3 then lpstart = 58.0+(params:get("V"..self.num.."_Scrll")*58.0)
    elseif self.num>2 and self.num<5 then lpstart = 174.0+(params:get("V"..self.num.."_Scrll")*58.0)
    else lpstart = 290.0+(params:get("V"..self.num.."_Scrll")*58.0) end
    softcut.loop_start(self.num,lpstart) softcut.position(self.num,lpstart) softcut.loop_end(self.num,lpstart+lenth)
  end
end

function Voic:inputselect(inz, itbl)
  local itabl = itbl
  if inz==1 then
    audio.level_eng_cut(1) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==2 then
    audio.level_eng_cut(0) audio.level_adc_cut(1) 
    softcut.level_input_cut(1,self.num,1.4) softcut.level_input_cut(2,self.num,0.0)
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==3 then
    audio.level_eng_cut(0) audio.level_adc_cut(1) 
    softcut.level_input_cut(2,self.num,1.4) softcut.level_input_cut(1,self.num,0.0)
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==4 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[1],self.num,1.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==5 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[2],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==6 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[3],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0)
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==7 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[4],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[3],self.num,0.0)
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==8 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[5],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[3],self.num,0.0) 
    softcut.level_cut_cut(itabl[4],self.num,0.0)
  end
end