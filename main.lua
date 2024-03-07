-- title:   tbd
-- author:  axunes
-- desc:    no
-- site:    https://axunes.net
-- license: MIT License
-- version: 0.1
-- script:  lua
function BOOT()
	music(5)
	table.insert(layers, {
		from = Vector2.new(0, 0),
		size = Vector2.new(30, 17)
	})

	table.insert(layers, {
		from = Vector2.new(0, 0),
		size = Vector2.new(30, 17)
	})
end

-- SHIT
function math.clamp(v, min, max)
	return math.max(min, math.min(max, v))
end

Vector2={new=function(a,b)end}Vector2={mt={__add=function(c,d)return Vector2.new(c.x+d.x,c.y+d.y)end,__sub=function(c,d)return Vector2.new(c.x-d.x,c.y-d.y)end,__mul=function(c,d)return Vector2.new(c.x*d.x,c.y*d.y)end,__eq=function(c,d)return c.x==d.x and c.y==d.y end},new=function(a,b)local e={x=a or 0,y=b or 0}e.clamp=Vector2.clamp;e.floor=Vector2.floor;setmetatable(e,Vector2.mt)return e end}Vector2.ZERO=Vector2.new()function Vector2.clamp(self,f,g)return Vector2.new(math.clamp(self.x,f.x,g.x),math.clamp(self.y,f.y,g.y))end;function Vector2.floor(self)return Vector2.new(math.floor(self.x),math.floor(self.y))end


-- GLOBALS
a = 0
flip = 0
camera = Vector2.new()
layers = {}
current_layer = 1 -- it's 1 index asshole

function TIC() -- main loop
	--cls()
	
	sound_test()

	vbank(1) -- foreground mode
	
	cls()
	print("playerpos: "..Player.x..", "..Player.y, 50,0, 2)
	player()

	vbank(0) -- background mode
	cls()

	draw_layers()

	if btnp(Button.A) then current_layer = current_layer + 1 end
	--draw_tiles(240//2, 136//2, 0, 0, 8, 8, 1 + math.sin(a/32*math.pi) * 0.5)
	--draw_tiles(0, 0, 0, 0, 8, 8, 1)
end

function draw_layers()
	for depth = #layers, 1, -1 do
		local layer = layers[depth]
		local ratio = (current_layer - (depth - 1) * 0.5) * 1
		local offset_ratio = ratio * 1

		draw_tiles(240 / 2 - Player.x * offset_ratio, 136 / 2 - Player.y * offset_ratio, layer.from.x, layer.from.y, layer.size.x, layer.size.y, ratio)
	end
end

function draw_tiles(x, y, from_x_tiles, from_y_tiles, width_tiles, height_tiles, scale)
	local width, height = width_tiles * 8, height_tiles * 8
	local from_x, from_y = from_x_tiles * 8, from_y_tiles * 8
	
	local u1, v1 = from_x, from_y
	local u2, v2 = width + from_x, from_y
	local u3, v3 = from_x, height + from_y
	local u4, v4 = width + from_x, height + from_y

	local x1, y1 = x - width // 2 * scale, y - height // 2 * scale
	local x2, y2 = x + width // 2 * scale, y - height // 2 * scale
	local x3, y3 = x - width // 2 * scale, y + height // 2 * scale
	local x4, y4 = x + width // 2 * scale, y + height // 2 * scale

	ttri(x1, y1, x2, y2, x3, y3, u1, v1, u2, v2, u3, v3, 1, 0)
	ttri(x2, y2, x3, y3, x4, y4, u2, v2, u3, v3, u4, v4, 1, 0)
end

-- OBJECTS
	function player()
			-- if btnp(Button.A) then a = a + 0.1 end
			
			if Player.s == "Idle" then
				if btn(Button.Right) then
					Player.h = 1
					Player.v = 0
					Player.spr_index = 262
					flip = 0
					a = 0
					Player.s = "Moving"
				end
				if btn(Button.Left) then
					Player.h = -1
					Player.v = 0
					Player.spr_index = 262
					flip = 1
					a = 0
					Player.s = "Moving"
				end
				if btn(Button.Down) then
					Player.h = 0
					Player.v = 1
					Player.spr_index = 256
					flip = 0
					a = 0
					Player.s = "Moving"
				end
				if btn(Button.Up) then
					Player.h = 0
					Player.v = -1
					Player.spr_index = 256
					flip = 0
					a = 0
					Player.s = "Moving"
				end
			end

			if Player.s == "Moving" then
					a = a + 2
					Player.x = Player.x + (2 * Player.h)
					Player.y = Player.y + (2 * Player.v)
					if a > 32 then
						a = 0
						Player.s = "Idle"
					end
				end

			
			
			
			
			-- render
			spr(Player.spr_index                                   , 240/2 - Player.size.x / 2, 136/2  - Player.size.y / 2 - (math.sin(a/32*math.pi) * 15), 0, 1, flip, 0, 3, 2)
			spr(Player.spr_index + 3 * (a > 0 and 1 or 0 ) + (16*2), 240/2 - Player.size.x / 2, 136/2  - Player.size.y / 2 - (math.sin(a/32*math.pi) * 15) + 16 , 0, 1, flip, 0, 3, 2)

		end

-- OTHER
	function sound_test()
			if btn(Button.A) then freq = freq - 1 end
			if btn(Button.B) then freq = freq + 1 end

			if btnp(Button.C) then vol = vol - 1 end
			if btnp(Button.D) then vol = vol + 1 end

			print(freq, 0,0)
			print(vol,0,16)

			--music
			poke4(0xff9d*2+1, vol)   -- vol
			poke4(0xff9d*2, freq>>8) -- freq hi
			poke(0xff9c, freq&0xff)  -- freq lo

			poke_waveform(0xff9e, wave1)
		end

-- SOUND
	function poke_waveform(address, data)
			-- update this so parameters are: (channel, wave)
			for i,v in ipairs(data)
			do
				poke4(address*2+i-1, v)
			end
		end
a = 0

Button = {
		Up    = 0,
		Down  = 1,
		Left  = 2,
		Right = 3,
		A     = 4,
		B     = 5,
		C     = 6,
		D     = 7
	}

Player = {
		i = 0, -- object id
		x = 0, -- x coor
		y = 0, -- y coor
		h = 0, -- hor speed
		v = 0, -- ver speed
		s = "Idle",  -- state
		spr_index = 256,
		size = Vector2.new(24, 32),
	}

-- MUSIC STUFF
	freq = 0
	vol  = 0

-- WAVEFORM DATA
	wave1 = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15}

-- <TILES>
-- 001:cccccccccccccdddeeecccccffddddddddcddddddddddddddeddddddddddddde
-- 002:ccccccccddddddddccceeeeedddffddddcccccccddddddddddddddddeddddddd
-- 003:444444444444444444322222443555554435cc554435c5564435556644355666
-- 004:4444444444444444222222242555552425cc552425c556242555662425566624
-- 005:4444444444344444443444444334444433344444333434442433344423343434
-- 006:4444444444444444444444444444444344444433444443334444333334443322
-- 007:3434333422244332333232234443333222222423333332333344334444243343
-- 008:4343423222222333333334442222444433332222333333333443344343434344
-- 009:4244444433333444323348884244444433333888334443442334434832443844
-- 010:4488888448888888444448888888888888888888484448888884888884448888
-- 017:ddddddddeedddcddddecdddfeddeddedeeffedddedefddddeeddedededfedede
-- 018:dcddfffeddddddeddddfeedeeddddcceddeeeddddddddededdffeedddddefdfe
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
-- 000:0000000000000000000000ff00000fbb0000fbcc000fbedd000fffed0000f8ce
-- 001:00ffff00ff9999ffaaaaaaaabbaaaabbcbbbbbbcdcbbbbcdddccccddddccccdd
-- 002:0000000000000000ff000000bbf00000ccbf0000ddebf000defff000ec8f0000
-- 003:0000000000000000000000ff00000fbb0000fbcc000fbedd000fffed0000f8ce
-- 004:00ffff00ff9999ffaaaaaaaabbaaaabbcbbbbbbcdcbbbbcdddccccddddccccdd
-- 005:0000000000000000ff000000bbf00000ccbf0000ddebf000defff000ec8f0000
-- 006:00000000fffff000fccccffffcccccccfccccccd0fcccddc00fcdccc000fddcc
-- 007:0000000000000000f0000000cfffffffdcfeeccbcce8cecccce8dceccce8fccc
-- 008:000000000000000000000000fff00000baafff00bbbaacf0ccccccffcccfff8f
-- 009:00000000fffff000fccccffffcccccccfccccccd0fcccddc00fcdccc000fddcc
-- 010:0000000000000000f0000000cfffffffdcfeeccbcce8cecccce8dceccce8fccc
-- 011:000000000000000000000000fff00000baafff00bbbaacf0ccccccffcccfff8f
-- 016:0000f8bd0000f8fd0000f8fd0000ffdd000fefbc000feffb00feeef90feeeeff
-- 017:cddddddcccddddccdccccccdbbbccbbbbbbbbbbbaabbbbaa9aaaaaa99d9999d9
-- 018:db8f0000df8f0000df8f0000ddff0000cbfef000bffef0009feeef00ffeeeef0
-- 019:0000f8bd0000f8fd0000f8fd0000ffdd000fefbc000feffb00feeef90feeeeff
-- 020:cddddddcccddddccdccccccdbbbccbbbbbbbbbbbaabbbbaa9aaaaaa99d9999d9
-- 021:db8f0000df8f0000df8f0000ddff0000cbfef000bffef0009feeef00ffeeeef0
-- 022:000fdcdc000fddcd000fdddc000feddd000eeeee0000feee0000feee0000feee
-- 023:cce8fcccccccccffdffffff8ccf88f88ddddffffefffffffeeeeeeefeeeeeeee
-- 024:cfff88f0f88f8f00f88ff000fff00000ff000000f0000000f0000000ef000000
-- 025:000fdcdc000fddcd000fdddc000feddd000eeeee0000feee0000feee0000feee
-- 026:cce8fcccccccccffdffffff8ccf88f88ddddffffefffffffeeeeeeefeeeeeeee
-- 027:cfff88f0f88f8f00f88ff000fff00000ff000000f0000000f0000000ef000000
-- 032:0fddeeeffdddeeeefdddeeee0fddeeee00fddeee00fdddee000fbcee000fcbcb
-- 033:f999999fffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 034:feeeddf0eeeedddfeeeedddfeeeeddf0eeeddf00eedddf00eecbf000bcbcf000
-- 035:0fddeeeffdddeeeefdddeeee0fddeeee00fddeee00fdddee000fdeee000feded
-- 036:f999999fffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 037:feeeddf0eeeedddfeeeedddfeeeeddf0eeeddf00eedddf00eecbf000bcbcf000
-- 038:0000feee0000feee0000feee0000ffee0000ffff0000fffc0000fffb0000000f
-- 039:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefeeeeeefbffffffccbcbcbfbbcbcbcfc
-- 040:eef00000eef00000eef00000eef00000fff00000bcf00000cbf00000bf000000
-- 041:0000feee0000feee0000feee0000ffee0000000f000000bf00000fbb0000ffbb
-- 042:eeeeeeeeeeeeeeeeeeeeeeeefeeeeeeeffaeeeecffffffbbfcffaffcfcbeecfb
-- 043:eef00000eef00000eef00000fef00000bff00000fff00000cf000000cbff0000
-- 048:000fbcbc000fcbcb000fbcbc000fdbcb000dbaaa000dbaaa000fbbbb0000ffff
-- 049:bcbccbcbcbcbbcbcbcffffcbcbf00fbcbdf00fdbbdf00fdbbf0000fbff0000ff
-- 050:cbcbf000bcbcf000cbcbf000bcbdf000aaabd000aaabd000bbbbf000ffff0000
-- 051:000fdede000feded000fcccc0000ffff00000000000000000000000000000000
-- 052:deffcbcbecfbbcbccff0ffbcff000fdb00000fdb000000fb000000ff00000000
-- 053:cbcbf000bcbcf000bcbdf000aaabd000aaabd000bbbbf000ffff000000000000
-- 054:0000fbcb0000fffc0000ffff0000fccb0000fccc0000fccc0000ffff00000000
-- 055:cbcbcbfbbcbcbcfcffffffffbbaaaaebcbbbbaaecccbbaaeffffffff00000000
-- 056:cf000000bf000000ff000000baf00000cbaf0000cbaf0000ffff000000000000
-- 057:000ffffb00fccffb0fcccbff00fcccbf000fccba0000fccb00000fc000000000
-- 058:bbbfecbfccbcbcbfccb00cfffb0000faf000000b0000000b0000000000000000
-- 059:ffb00f00fbcbbff0eaecff00aaeff000baf00000bf000000f000000000000000
-- </SPRITES>

-- <MAP>
-- 000:111111111120111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:102011211121102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:112140211020102011211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:112141201121112110201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:103040201030402010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:113141211131412111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:103141201031412010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- 012:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011
-- 013:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- 014:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011
-- 015:102010201020102010201020102010201020102010201020102010201020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
-- 016:112111211121112111211121112111211121112111211121112111211121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011
-- </MAP>

-- <WAVES>
-- 000:22445567778888888888877777765543
-- 001:8bdca879bef99aaccccccac146875324
-- 002:0123456789abc2234123456789abcdef
-- 003:ff00ff00ff00ff00ff00ff00ff00ff00
-- 004:f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0
-- 005:789abcdeffdca9764210002234566777
-- 006:789aba85777777777788888778777777
-- </WAVES>

-- <SFX>
-- 000:a200a200a200920082007200d200d200d2002200e200820082009200a200d200d200f200f200f200f200f200f200f200f200f200f200f200f200f200407400290000
-- 001:0100110011002100310041004100510051005100610061007100710071007100810f810d810c910d910ea10fb100b101c102d103d104e103e102e1003100000000ff
-- 002:b300a40093108310735053504380338043c043c05380638073509350c310f310f300f300f300f300f300f300f300f300f300f300f300f300f300f3009704020f0f00
-- 003:05070507050605052505250425033503350335024501450155014501550075006500650095007500a5009500a500c500d500e50fe50ff50fe50ff50f830000000000
-- 004:cf00df00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00467000000000
-- 005:060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600060006000600007400000000
-- 006:e100d140c160b190a16091408100710081009100a100b100c100d100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f1005654000e0600
-- 010:270827f827f037073707370747074707570757076700770077007700770087008700870097009700a700b700b700c700c700c700d700e700e700f700c30000002131
-- 015:25003530457055a065e0757065a0553045703500553045003500250005000500050005000500050005000500050005000500050005000500050005004740000a4801
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
-- 020:40000260000870000290000cb00006000000c0000ab00002000000100000900006700000600308000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:a00006000000000000000000d00006000000000000000000f00006000000500008000000f00006000000000000800008c00008000000a00008000000d00008c00008000000500008a00008000000f0000800000050000a000000d00008c00008a00008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:800016000000000000000000800016000000000000000000800016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:a00016000010000000000000a00016000000000000000000a00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b00006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:d00016000010000010000000d00016000000000000000000c00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:500018000010000000000010400018000000000000000000f00016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:1410102810103c10104020101420102820103c20104030100000000000000000000000000000000000000000000000000400ff
-- 001:9beb3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0
-- 002:d83f040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ef
-- 003:194315000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040040
-- 004:000c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:5905020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000df
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c7d00ce6900b65500d2480499ffda59ffb764257179ffffff23baff18a2e01185ad04ca950079a5003475001729
-- 001:1a1c2c7d00ce6900b65500d2480499ffda59ffb764257179ffffff23baff18a2e0117dad046695004970002c47001729
-- </PALETTE>

