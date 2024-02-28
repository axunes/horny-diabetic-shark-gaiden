-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

a = 0
b = 0

freq = 0
vol = 0

function BOOT()
	
end
-- vvvvpppp pppppppp
function TIC()
	cls(13)

	if btn(0) then b = b - 1 end
	if btn(1) then b = b + 1 end
	if btn(2) then a = a - 1 end
	if btn(3) then a = a + 1 end

	if btnp(4) then freq = freq - 1 end
	if btnp(5) then freq = freq + 1 end

	if btnp(6) then vol = vol - 1 end
	if btnp(7) then vol = vol + 1 end
	
	print(freq, 0,0)
	print(vol,0,16)

	rect(a,b,16,24,2)
	
	--music
	poke4(0xff9d*2+1, vol)   -- vol
	poke4(0xff9d*2, freq>>8) -- freq hi
	poke(0xff9c, freq&0xff)  -- freq lo
	
	wave1 = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15}
	
	wave(0xff9e, wave1)
end

function wave(address, data)
	for i,v in ipairs(data)
	do
		poke4(address*2+i-1, v)
	end
end


-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

