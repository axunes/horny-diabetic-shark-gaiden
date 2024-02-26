-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua



vec2 = {
	meta = {
		__add = function (s, v) 
			return vec2.new(s.x + v.x, s.y + v.y)
		end
	},

	new = function(x, y)
		local v = {
			x = x or 0,
			y = y or 0,
		}
		
		setmetatable(v, vec2.meta)
	
		return v
	end
}



player = {
	SPEED = 2,
	MAX_ACCEL = 10,

	pos = vec2.new(),
	
	move = function(s, v)
		s.pos = s.pos + v
	end
}


function TIC()
	cls()
	player:move(get_arrows())

	print(player.pos.x,84,84)
end


function get_arrows()
	return vec2.new(
		(btn(3) and 1 or 0)-(btn(2) and 1 or 0),
		(btn(0) and 1 or 0)-(btn(1) and 1 or 0)
	)
end

-- <TILES>
-- 001:decdddddeeceeeeeddddddddefffeeedeecccdddddddddeddeddddfeddddddfe
-- 002:edecdddddecddddedededeeeeddddddeddddddffeeddddeddecddddeeddddddd
-- 003:444444444444444444322222443555554435cc554435c5564435556644355666
-- 004:4444444444444444222222242555552425cc552425c556242555662425566624
-- 017:dedddddfeedddcddddecdddfeddeddedeeffedddedefddddeeddedededfedede
-- 018:ecedfffedddfdeedfedfeedeeddddcceddeeeddddddddededdffeedddddefdfe
-- 019:44322222443555554435cc554435c55644355566443556664432222244444444
-- 020:222222242555552425cc552425c5562425556624255666242222222444444444
-- </TILES>

-- <SPRITES>
-- 001:dd000000ddddddddeeedddddeeeeeeeeeeeeeeeeeeeecc0ceeeecc0ceeeeecce
-- 002:0000000000000000ddd00000edddddd0eeeeeee0eeee0ee0eeeeeee0eeeeeee0
-- 017:eeeeeeeeeeeeeeeeeeeeeee0eeeeeecc00000000000000000000000000000000
-- 018:eec0cc00c0cc0000cc0c00000c00000000000000000000000000000000000000
-- </SPRITES>

-- <MAP>
-- 013:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- </WAVES>

-- <SFX>
-- 000:9000700020003000400040005000600060007000700080008000900090009000a000a000b000c000c000d000d000d000d000e000e000f000f000f000120400000000
-- 001:0100110011002100310041004100510051005100610061007100710071007100810f810d810c910d910ea10fb100b101c102d103d104e103e102e1005140000000ff
-- 002:b300a40093108310735053504380338043c043c05380638073509350c310f310f300f300f300f300f300f300f300f300f300f300f300f300f300f3009704020f0f00
-- 003:05070507050605052505250425033503350335024501450155014501550075006500650095007500a5009500a500c500d500e50fe50ff50fe50ff50f834000000000
-- 004:cf00df00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00464400000000
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
-- 056:800016000000000000000000800016000000000000000000800016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:a00016000010000000000000a00016000000000000000000a00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:d00016000010000010000000d00016000000000000000000c00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:500018000010000000000010400018000000000000000000f00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1410002810003c10004020001420002820003c2000403000000000000000000000000000000000000000000000000000ae00df
-- 001:9beb3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050
-- 002:d83f040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ef
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c7d00ce6900b65500d2480499ffda59ffb76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

