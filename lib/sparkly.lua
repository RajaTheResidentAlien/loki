Sparkly={} spark={{0,1,0,0,1,0,0,1,0},{0,0,1,0,1,0,1,0,0},{0,0,0,1,1,1,0,0,0},{1,0,0,0,1,0,0,0,1}}
mu = require('musicutil')
function Sparkly:new(num,xx,rws,cls,grd) 
	local s = setmetatable({}, { __index = Sparkly })
	s.busy = 0 s.num = num s.phs = 1 s.sbusy = 0 s.grd=grd
	s.metro=metro.init() s.metro.event=s.applycllsn1 s.metro.time=0.1 s.metro.count=15 s.prvspd=1 s.prvvol=1

	function s.applycllsn1(stg) 
	  local spd=mu.interval_to_ratio(math.random(s.metro.count))
	  if math.random(2)>1 then params:set("V"..s.num.."_Spd",(spd/s.metro.count)*stg) 
	  else params:set("V"..s.num.."_Spd",(spd/s.metro.count)*(s.metro.count-stg)) end
	  if stg>=(s.metro.count-1) then params:set("V"..s.num.."_Spd",s.prvspd) end
	end
	function s.applycllsn2(stg)
	  local spd=mu.interval_to_ratio(math.random(s.metro.count)*2)
	  if math.random(2)>1 then params:set("V"..s.num.."_Spd",util.round(spd*stg,0.0001)) 
	  else params:set("V"..s.num.."_Spd",util.round(spd*(s.metro.count-stg),0.0001)) end
	  if stg==(s.metro.count-3) then 
	    if math.random(2)>1 then s.prvvol = params:get("V"..s.num.."_Vol") params:set("V"..s.num.."_Vol",0) end
	  elseif stg==(s.metro.count-2) then params:set("V"..s.num.."_Vol",s.prvvol) end
	end
	s.dir = (math.random(0,1)*2)-1 s.ycoord = s.num + 2 s.xcoord = util.wrap(xx,1,cls)
	return s
end

function Sparkly:seq(step_x,step_y) 
  self.phs = util.wrap(self.phs + (step_x * (self.dir*5)), 1, 4)
  if (step_x > 0) then 
    self.xcoord = util.wrap(self.xcoord + (step_x * self.dir),1,16) params:set("V"..self.num.."_Phase",self.xcoord/16)
  end
  if (step_y > 0) then self.ycoord = util.wrap(self.ycoord + step_y,3,8) end
  return math.floor(self.xcoord+0.5),self.ycoord,math.floor(self.phs)
end

function Sparkly:go(noff) self.busy = noff; self.dir = (math.random(0,1)*2)-1 params:set("V"..self.num.."_Go",self.busy) end

function Sparkly:rev() 
  self.dir = self.dir * -1 
  params:set("V"..self.num.."_Spd",params:get("V"..self.num.."_Spd")*self.dir)
end

function Sparkly:drw(rwoffst,grd)
  if (self.busy > 0) then
    local ps local wy local ex
    ex,wy,ps=sprklz[self.num]:seq(1/math.random(16),0)
    for ii = 1,3 do 
		  for jj = 1,3 do 
			  local xy = jj + (ex - 2) local yx = ii + (wy - 2) local zz = ((ii - 1) * 3) + jj
			  if ((xy>0)and(xy<17)) and ((yx>2)and(yx<9)) then 
			     local noff=spark[ps][zz] 
			     if noff>0 then grd:led(xy,yx+rwoffst,noff*12) end 
			  end
		  end
    end
  end
  if self.num<4 then -- check 2 rows apart(reverse direction of both, if collision)
    if (sprklz[self.num+3].busy>0) and (self.busy>0) then 
      if math.abs(self.xcoord - sprklz[self.num+3].xcoord)<3 then -- collision-check
        if self.sbusy<1 then
          if math.random(0,1)>0 then 
            local swtch=math.random(2)  clock.run(drrrop,self.num) self.sbusy=1
              if swtch==1 then self.metro.event=self.applycllsn1 else self.metro.event=self.applycllsn2 end
              self.metro:start((math.random(4)+1)*0.05,math.random(4)+8) 
          end
        end
      end
    end
  elseif self.num<5 then -- check alternate rows(reverse direction of both, if collision)
    if (sprklz[self.num+2].busy>0) and (self.busy>0) then 
      if math.abs(self.xcoord - sprklz[self.num+2].xcoord)<3 then 
        self.dir = self.dir * -1 
        sprklz[self.num+2].dir = sprklz[self.num+2].dir * -1
      end
    end
  elseif self.num<6 then --check consecutive rows(reverse direction of one, possibly the other, and random-kill 1)
    if (sprklz[self.num+1].busy>0) and (self.busy>0) then 
      if math.abs(self.xcoord - sprklz[self.num+1].xcoord)<3 then 
        local wutkill = math.random(0,1)
        sprklz[self.num]:rev()            sprklz[self.num+wutkill]:go(util.clamp(math.random(0,2),0,1)) 
        if math.random(0,1)>0 then sprklz[self.num+1]:rev() end
      end
    end
  end
	if voices[self.num].mde>1 then
	   grd:led(voices[self.num].tixx+1,(self.num+2)+rwoffst,voices[self.num].pl*11+4)
	   grd:led(self.num+1,math.floor(voices[self.num].tixx/16)+1+rwoffst,voices[self.num].pl*11+4) 
	 else
	  grd:led((voices[self.num].prvstp%16)+1,(self.num+2)+rwoffst,voices[self.num].pl*11+4)
	 end
end

function drrrop(num)
  local ycrd=sprklz[num].ycoord
  sprklz[num].ycoord=sprklz[num+3].ycoord
  clock.sleep((math.random(4)*0.5)+1)
  sprklz[num].ycoord=ycrd
  sprklz[num].sbusy=0
  return
end