local m1 = require "MOD1"
local M={}
--M.popu={{}}

function M.checkErrors(pop,msg,loss)
  loss = loss or 1
  for i =1,#pop do
    for j =1,#pop do
      if i ~=j then assert(pop[i].id~=pop[j].id,"Clones: "..msg) end
    end
    if loss==1 then assert(pop[i].loss,"Loss: "..msg) end
  end
end
--
--[[
function M.genPop(size,neu,cons)
  cons= cons or {}
  local out={}
  for i =1, size do out[i] = m1.create(neu,cons,1)  end
  --for i =1, size do M.popu[1][i] = {['nG']=neu,['cG']=cons,['ecG']={}} print(M.popu[1][i]) end
  return out
end
---
function M.mutPop(pop,ws,rw,c,n)
  math.randomseed(os.time())
  ws=ws or 10
  rw = rw or 4
  c = c or 20--2
  n = n or 1
  for i= 1, #pop do
    local dice = math.random(0,100)
    local transfer = pop[i]
    if dice <c then m1.conMut(transfer,i*os.time()) print("Mut", i*os.time()) end -- <------ AQUI 
  end
end]]
---
function M.evalPop(pop,inData,exData)
  for i,j in pairs(pop) do
    local l =m1.globLoss(j, inData,exData) ---HERE
    pop[i].loss=l
  end
  table.sort(pop,function (a,b) return math.abs(a.loss)<math.abs(b.loss) end)
  M.checkErrors(pop,"evalPop")
end
--
function M.evalGain(pop)
  table.sort(pop,function (a,b) return math.abs(a.pontos)>math.abs(b.pontos) end)
end
---
function M.gen(num)
  local out ={}
  for i = 1, num do
    out[i]=m1.create({-1,-2,-3,-99,-98},{})
  end
  M.checkErrors(out,"gen",0)
  return out
end
---
function M.mutSpecIni(spec)
  for i = 1, #spec do
    m1.conMut(spec[i],math.random())
  end
  M.checkErrors(spec,"mutSpec",0)
end
--
function M.mutSpec(spec,rwmC,swmC,nC,cC)
  rwmC = rwmC or 0.1
  swmC = swmC or 0.5
  nC = nC or 0.02
  cC = cC or 0.05
  for _,i in pairs(spec) do
    if math.random()<rwmC then m1.rwMut(i, 0.5) print("Random Weight!") end
    if math.random()<swmC then m1.swMut(i, 0.05) print("Weight Shift!") end
    if math.random()<nC then m1.nMut(i) print("New Neuron!") end
    if math.random()<cC then m1.conMut(i) print("New Connection!") end
  end
  M.checkErrors(spec,"mutSpec",0)
end
--
function M.selSpec(spec,survR)
  local nSurv = math.ceil(#spec*survR)
  local out= {}
  for i =1, #spec do
    if i <= nSurv then
      --spec[i] = spec[i]
    else
      spec[i]= nil
    end
  end
  M.checkErrors(spec,"selSpec")
end
----
function M.nxtGen(spec,survR,size)
  size = size or #spec
  local out ={}
  out[1],out[2]=spec[1],spec[2]
  M.selSpec(spec,survR)
  while #out <= size do
    for _,i in pairs(spec) do
      for _, j in pairs(spec) do
        if i.id ~= j.id then
          out[#out+1]=m1.breed(i,j)
        end
      end
      if #out == size then print(#out) break end
    end
  end
  print("OUT:",#out, "\n")
  --M.deep_print(out)
  M.checkErrors(out,"nxtGen",0)
  return out
end
--
function M.assexualGen(spec,nSurv, same)
  table.sort(spec,function (a,b) return math.abs(a.pontos)>math.abs(b.pontos) end)
  local best={}
  for i,j in pairs(spec) do
    if i > nSurv then spec[i]=m1.deep_clone(spec[i%nSurv+1])
    else best[i]=m1.deep_clone(j,true) end
  end
  if not(same) then M.mutSpec(spec) end
  for i, j in pairs(best) do
    spec[i]=j
  end
end
--
--local l =M.genPop(10,{-1,-2,-99})
--M.mutPop(l)
--M.popu[1][1].cG={{-1,-99,2,1}}
--M.evalPop({{[-1]=1,[-2]=2},{[-1]=2,[-2]=1}},{{[-99]=3},{[-99]=5}})

--M.deep_print(l)

return M