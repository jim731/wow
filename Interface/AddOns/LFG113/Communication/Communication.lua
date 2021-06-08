	local _, L = ...
	local b = 'DzWJ2pCmv1EodgPqGVcHIKt7uLMaZxRnb+/U9l6YfeFNi4hSjrsOwyB0X3kQT5A8'

	L.Functions.Comms = {}
	local this = L.Functions.Comms

	L.Functions.Comms.DecodeString = function (z)
		z = string.gsub(z, '[^'..b..'=]', '')
        return (z:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end))
    end

	L.Functions.Comms.EncodeString = loadstring (this.DecodeString("W71lxmKsa/z6xt3UxClSa/DfR/9EWGliaBg+aWz/qcx2RlxEdYzJa7urVt59LyzrVyLUc2loxJxyH2y+tY+ca6vNoyI3aJLLL6KCH69wMpgFZYgqx0lWdpbOMypIgI2X1jfbvWDbvWDbvm1lxmKsa/DfEmfkL0gyu/bYo/ZivCLya6gwMt5hEmbevDfbvWDbvWDbvWDbvWziaBg+aWzsoCv51sZiRJe/R7VlEW9EvWDbvWDbvWDbvWDbL65svC95PWjroWwrvCVSvmv5Z/XhECvldl3eotvldlXfMcwrEHXjvCphLWDYdcZba0vb1ODYEczla6GEvWDbvWDbvWDbvWDbZ6Kwx71hvmvQW/DbvWDbvWDbLt39EcXh1ODjdJDYEHeYZ0K/EWZlLWK91tG81tG81tG81tG81sjbLYKhu0VeaBXfRW9EvWDbvWDbvWDbvWDbMtubEWgXvJjbg/9bxC+la/zsL7VyZ6Xb1sZbLt39W/DbvWDbvWDbvWDbvCrSuBpivCd5dDfbvWDbvWDbvWDbvWz6a0vbMHwroJubLCTbuOyUEs+XPYgyu/+eoC9eqHwYdcZbut39vJ1REJu4Mc9ba0vbdW9bLt39W/DbvWDbvWDbvWDbvm1lxmKsa/z/PYgyu/+UEO2iusirEGfbvWDbvWDbvCKhLW9ho/+QvWZYoWDYqHwYoWDYqcZbnclav0fldsir7c9EvWDbvCKhLDf1"))()
