-- title:   tbd
-- author:  axunes
-- desc:    no
-- site:    https://axunes.net
-- license: MIT License
-- version: 0.1
-- script:  lua

function math.clamp(v, min, max)
	return math.max(min, math.min(max, v))
end

Button = {
	p1 = {
		up = 0,
		down = 1,
		left = 2,
		right = 3,
		a = 4,
		b = 5,
		c = 6,
		d = 7
	},
	p2 = {
		up = 8,
		down = 9,
		left = 10,
		right = 11,
		a = 12,
		b = 13,
		c = 14,
		d = 15
	},
	p3 = {
		up = 16,
		down = 17,
		left = 18,
		right = 19,
		a = 20,
		b = 21,
		c = 22,
		d = 23
	},
	p3 = {
		up = 24,
		down = 25,
		left = 26,
		right = 27,
		a = 28,
		b = 29,
		c = 30,
		d = 31
	}
}

Vector2 = {new = function(x, y) end}

Vector2 = {
	mt = {
		__add = function (a, b) 
			return Vector2.new(a.x + b.x, a.y + b.y)
		end,

		__sub = function (a, b) 
			return Vector2.new(a.x - b.x, a.y - b.y)
		end,

		__mul = function (a, b) 
			return Vector2.new(a.x * b.x, a.y * b.y)
		end,

		__eq = function (a, b) 
			return (a.x == b.x) and (a.y == b.y)
		end
	},

	new = function(x, y)
		local v = {
			x = x or 0,
			y = y or 0,
		}

		v.clamp = Vector2.clamp
		v.floor = Vector2.floor
		
		setmetatable(v, Vector2.mt)
	
		return v
	end
}

Vector2.ZERO = Vector2.new()


function Vector2.clamp(self, min, max)
	return Vector2.new(
		math.clamp(self.x, min.x, max.x),
		math.clamp(self.y, min.y, max.y)
	)
end

function Vector2.floor(self)
	return Vector2.new(
		math.floor(self.x),
		math.floor(self.y)
	)
end


local player = {
	ACCELERATION = 0.5,
	DECELERATION = 0.5,
	MAX_VELOCITY = 5,

	position = Vector2.new(),
	velocity = Vector2.new(),
	
	tick = function(self, v)
		local joy_vector = get_arrows()
		if joy_vector == Vector2.ZERO then
			self.velocity = self.velocity - Vector2.new(
				self.velocity.x > 0 and self.DECELERATION or self.velocity.x < 0 and -self.DECELERATION or 0,
				self.velocity.y > 0 and self.DECELERATION or self.velocity.y < 0 and -self.DECELERATION or 0
			)
		else
			self.velocity = (self.velocity + joy_vector * Vector2.new(self.ACCELERATION, self.ACCELERATION)):clamp(Vector2.new(-self.MAX_VELOCITY, -self.MAX_VELOCITY), Vector2.new(self.MAX_VELOCITY, self.MAX_VELOCITY))
		end

		self.position = (self.position + self.velocity):floor()
	end
}

freq = 0
vol = 0

function TIC()
	cls()
	player:tick()

	print(player.velocity.x,player.position.x,player.position.y)

	if btnp(4) then freq = freq - 1 end
	if btnp(5) then freq = freq + 1 end

	if btnp(6) then vol = vol - 1 end
	if btnp(7) then vol = vol + 1 end
	
	print(freq, 0,0)
	print(vol,0,16)

	rect(player.position.x, player.position.y, 16, 24, 2)
	
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


function get_arrows()
	return Vector2.new(
		(btn(Button.p1.right) and 1 or 0) - (btn(Button.p1.left) and 1 or 0),
		(btn(Button.p1.down) and 1 or 0) - (btn(Button.p1.up) and 1 or 0)
	)
end

-- <TILES>
-- 001:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 002:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 003:444444444444444444322222443555554435cc554435c5564435556644355666
-- 004:4444444444444444222222242555552425cc552425c556242555662425566624
-- 005:4444444444344444443444444334444433344444333434442433344423343434
-- 006:4444444444444444444444444444444344444433444443334444333334443322
-- 007:3434333422244332333232234443333222222423333332333344334444243343
-- 008:4343423222222333333334442222444433332222333333333443344343434344
-- 009:4244444433333444323348884244444433333888334443442334434832443844
-- 010:4488888448888888444448888888888888888888484448888884888884448888
-- 017:ffffffffffffffffffffffffffffffffffffffffffffffff5555555555555555
-- 018:ffffffffffffffffffffffffffffffffffffffffffffffff555fffff555fffff
-- 019:44322222443555554435cc554435c55644355566443556664432222244444444
-- 020:222222242555552425cc552425c5562425556624255666242222222444444444
-- 021:2233333422222223342122224131132331131321311111113131111341111133
-- 022:3232422222222222322222211131331111111111131111111131111314313314
-- 023:2234433233222233433333334444334322222322333333333322222244333333
-- 024:2223224333333322344344333444344422323332333333332333343433433444
-- 025:3344344422333444434348483343444443444488423448482344448824334888
-- 026:8484888844844888848888888444888844444888488888884448888844888888
-- 033:ffffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeedddddddddddddddd
-- 034:fffffffefffffffefffffffeeeeeeeedeeeeeeedeeeeeeeddddddddcdddddddc
-- 035:cccccccccccccdddeeecccccffddddddddcddddddddddddddeddddddddddddde
-- 036:ccccccccddddddddccceeeeedddffddddcccccccddddddddddddddddeddddddd
-- 037:dbbbbbbddccccccddcddcdccdddddddddddddddddddddddddddddddddddddddd
-- 038:dddddddddcbbddddddccdddddddddddddddddddddddddddddddddddddddddddd
-- 039:0000000000000000000000000000000000000000000dddd0111ddd8d00dddddd
-- 049:ddddddddcccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 050:dddddddccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 051:ddddddddeedddcddddecdddfeddeddedeeffedddedefddddeeddedededfedede
-- 052:dcddfffeddddddeddddfeedeeddddcceddeeeddddddddededdffeedddddefdfe
-- 053:dddddddddddddddddddddddddddddddddddddddddeddddddd9edddddddeeeeee
-- 054:ddddddddddddddddddddddddddddddddddddddddddddddddddeedeeeee9eee9d
-- </TILES>

-- <SPRITES>
-- 001:000000dd0000dddd000fdeee000feeee00feeeee0ffeeeee0feeeeeeffeeeeee
-- 002:00000000dddddd00edddddddeeeeeeedeeeeeeeeeecc0ceeeecc0ceeeeecceee
-- 003:0000000000000000d0000000ddddd000eeeee000ee0ee000eeeee000eeeee000
-- 004:000000dd0000dddd000fdeee000feeee00feeeee0ffeeeee0feeeeeeffeeeeee
-- 005:00000000dddddd00edddddddeeeeeeedeeeeeeeeeecc0ceeeecc0ceeeeecceee
-- 006:0000000000000000d0000000ddddd000eeeee000ee0ee000eeeee000eeeee000
-- 017:feeeeeeeffeeeeee0ffeeeee00ffeeee000fffff00f0ffff0000fffe000efeee
-- 018:eeeeeeeeeeeeeec0eeeee0cceeeecc0cff000000ff000000eeff0000eff00000
-- 019:c0cc0000cc0000000c0000000000000000000000000000000000000000000000
-- 020:feeeeeeeffeeeeee0ffeeeee00ffeeee000fffff00f0ffff0000fffe000efeee
-- 021:eeeeeeeeeeeeeec0eeeee0cceeeecc0cff000000ff000000eeff0000eff00000
-- 022:c0cc0000cc0000000c0000000000000000000000000000000000000000000000
-- 033:000efeee000efeee000ffeee000ffeee000ffeee000ffeee0000feee0000feec
-- 034:eff00000e0f00000eef00000eef00000ee000000ee000000e0000000cc000000
-- 036:000efeee000efeee000ffeee000ffeee000ffeee000ffeee0000feee00ffffee
-- 037:eff00000e0f00000eff00000eff00000ef000000ff000000f0000000fff00000
-- 049:0000fffd0000fffd00000fff0000f0ff00000fff000000ee0000dddd0000dddd
-- 050:cd000000ed000000fff00000ff000000ff000000eeff0000dddd0000dddd0000
-- 052:000fffee0d0ffffe0dd0fff0dddd0ff00dddddf00ddddde0000dddd0000dddd0
-- 053:fffd0000fffff0000ffff00d0f0eeccd0f0fccdd0e0efddd0ddddddd00ddddd0
-- 054:0000000000000000dd000000dd000000dd000000d00000000000000000000000
-- </SPRITES>

-- <MAP>
-- 005:708070807080708070807080708090a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:718171817181718171817181718191a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:708070807080708070807070708090a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:718171817181718171817171718191a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:304030407080708070708070708090a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:314131417181718171718171718191a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:506050605060506050605060506090a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:516151615161516151615161516191a10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:122212221222122212221222122212221212221222122212221212221222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:132313231323132313231323132313231313231323132313231313231323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:235678aabcccdddeddcdddccba865310
-- 001:8bdca879befda75689a8520146875324
-- 002:0123456789abcdef0123456789abcdef
-- 003:ff00ff00ff00ff00ff00ff00ff00ff00
-- 004:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 005:789abcdeffdca9764210002234566777
-- 006:789aba85777777777788888778777777
-- </WAVES>

-- <SFX>
-- 000:0000100020003000400050006000700080009000a000b000c000d000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000504400000000
-- 001:0100110011002100310041004100510051005100610061007100710071007100810f810d810c910d910ea10fb100b101c102d103d104e103e102e1003100000000ff
-- 002:b300a40093108310735053504380338043c043c05380638073509350c310f310f300f300f300f300f300f300f300f300f300f300f300f300f300f3009704020f0f00
-- 003:05070507050605052505250425033503350335024501450155014501550075006500650095007500a5009500a500c500d500e50fe50ff50fe50ff50f834000000000
-- 004:cf00df00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00464000000000
-- 005:06000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060000b400000000
-- 006:e100d140c160b190a16091408100710081009100a100b100c100d100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f1005644000e0600
-- </SFX>

-- <PATTERNS>
-- 000:800002000000000000000000000000000000f00002000000000000000000000000000000800002000000000000000000800002000000000000000000000000000000f00002000000000000000000000000000000800002000000000000000000800002000000000000000000000000000000f00002000000000000000000000000000000800002000000000000000000800002000000000000000000000000000000f00002000000000000000000000000000000800002000000000000000000
-- 001:800002000000000000000000000000000000f00002000000000000000000000000000000800002000000000000000000800002000000000000000000000000000000f00002000000000000000000000000000000c00002000000000000000000d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000
-- 002:d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000c00002000000000000000000000000000000800004000000000000000000000000000000c00002000000000000000000c00002000000000000000000000000000000800004000000000000000000000000000000c00002000000000000000000
-- 003:a00002000000000000000000000000000000500004000000000000000000000000000000a00002000000000000000000a00002000000000000000000000000000000500004000000000000000000000000000000a00002000000000000000000d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000d00002000000000000000000000000000000800004000000000000000000000000000000d00002000000000000000000
-- 004:e00018f00018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00018000000000000000000c00018000000000000000000d00018000000000000000000f0001800000000000000000000001000000050001a000000000000000000000010000000800018000000000010000010000010000000000000000000000000000000000000000000c00018000000000000000000000000000000000000000000
-- 005:e00018f00018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00018000000000000000000c00018000000000000000000d00018000000000000000000f00018000010000000000000000000000000b0001ac0001a00000000000000000000000080001a000000000010000000000000000000000000000000000000000000000000000000c00018000000000000000000000000000000000000000000
-- 006:c00018d00018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00018000000000000000000a00018000000000000000000d00018000000000000000000c00018000000000000000000000000000000f00018000000000000000000000000000000800018000000000000000000000000000000000000000000000000000000000000000000500018000000000000000000f00016000000000000000000
-- 007:f00016e00016000000000000800018000000a00018000000000000000000800018000000000000000000f00016e00016000000000000800018000000a00018000000c00018000000000010000010c00018d00018c00018000000a00018000000000010000010b00018c00018a00018000000800018000000000000000000900018a00018800018000000400018000000000000000000a00018000000000010000010900018a00018000010000010c00018000010a00018000000800018000010
-- 008:00000000000000001000000000000000000000000000000080001a00001080001a000000a0001a000000000010000000b0001ac0001a000000000000000000000000d0001a000000000000000000000010000000f0001a000000000000000000f0001a000000000000000000000000000000a0001a000000000000000000000000000000000000000000000000000000000000000000000000000000b0001ac0001a000000000000a0001a00000080001a000000f0001800000080001a000000
-- 009:000000000000000000000000a0001a00000080001a000000000000000000000000000010a0001a000000000000000000c0001a000000000000000000000000000000c0001ad0001a000000000000000010000000c0001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:800002000000800002000000600004000000800002000000800002000000800002000000600002000000800002000000000000000000800004000000500002000000500004000000600002000000600004000000700002000000700004705402800402000000800002000000600004000000800002000000600004000000800004000000600002000000800002000000000000000000800004000000500002000000500004000000600002000000600004000000700002000000700004705402
-- 013:000000000000000000000000837216000000000000000000000000000000000000000000837216000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:80001af00018b00018700018f00016000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:40003000000000003000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c00000000000000000040003000000000000000000040004c000000000000000000
-- 016:800002000000800004000000800002000000800004800002000000800004d00004e00004f00004600006f00004d00004800002000000800004000000800002000000800004800002000000800004d00004e00004f00004600006f00004d00004800002000000800004000000800002000000800004800002000000800004d00004e00004f00004600006f00004d00004800002000000800004000000800002000000800004800002000000800004d00004e00004f00004600006f00004d00004
-- 017:600068000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:a0001a00000000000060001a000000000010d00018000000000000c00018000000000010800018000010f00018000010500018000000000010600018000000000010d00018000000000000c00018000000000000800018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:40003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c00000040003000000040004c000000
-- 056:800016000000000000000000800016000000000000000000800016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:a00016000010000000000000a00016000000000000000000a00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:d00016000010000010000000d00016000000000000000000c00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:500018000010000000000010400018000000000000000000f00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1410102810103c10104020101420102820103c2010403010000000000000000000000000000000000000000000000000ae00df
-- 001:9beb3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0
-- 002:d83f040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ef
-- 003:194315000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c7d00ce6900b65500d2480499ffda59ffb7642571793414403b5dc941a6f681daeec2deff94aad6566cd2333c99
-- </PALETTE>

