local module = {}
module.__index = module
local fitVertical = 10

--[[
function love.graphics.getHeight()
  return 425
end
function love.graphics.getWidth()
  return 752
end
function love.graphics.getDPIScale()
  return 2.4047058823529
end
function love.system.getOS()
  return 'Android'
end
--]]

local dpiScale = love.graphics.getDPIScale()
local screenW = love.graphics.getWidth() * dpiScale-- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local screenH = love.graphics.getHeight()* dpiScale -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local screenRatio = love.graphics.getWidth() / love.graphics.getHeight() -- ranges from 1.7 to 2.1, typically 16/9 = 1.77
local size = screenH / fitVertical
local font = love.graphics.newFont('fonts/fa-solid-900.ttf', size/2)
--print('screenW, screenH, font:getHeight(), size', screenW, screenH, font:getHeight(), size)
--print('love.graphics.getHeight()', love.graphics.getHeight())
--print('love.graphics.getWidth()', love.graphics.getWidth())
--print('love.graphics.getDPIScale()', dpiScale)

function module.new(name, col, row, tapped)
  assert(names[name], 'unknown icon name')
  instance = setmetatable({
      name = name,
      col = col or 0,
      row = row or 0,
      x = x,
      y = y,
      fontW = font:getWidth(names[name]),
      fontH = font:getHeight(),
      tapped = tapped,
    }, module)
  if col >= 0 then
    instance.x = .5 + (col) % (fitVertical * screenRatio)
  else
    instance.x = (.5 + fitVertical * screenRatio + col) % (fitVertical * screenRatio)
  end
  if row >= 0 then
    instance.y = .5 + row % fitVertical
  else
    instance.y = (.5 + fitVertical + row) % fitVertical
  end
  return instance
end

function module:draw()
  love.graphics.push('all')
  love.graphics.reset()
  love.graphics.scale(
    love.system.getOS() ~= 'Android'
      and size
      or size / dpiScale)
  love.graphics.translate(self.x, self.y)
  --love.graphics.translate(self.x, self.y)
  love.graphics.setFont(font)
  love.graphics.stencil(function ()
      love.graphics.setColorMask(true, true, true, true)
      love.graphics.setColor(.23, .27, .40)
      love.graphics.circle('fill', 0, 0, .4)
    end, 'replace', 1, false)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.setColor(.75, .80, .86)
  love.graphics.scale(1/size)
  love.graphics.print(names[self.name], -self.fontW / 2, -self.fontH / 2)
  --love.graphics.setStencilTest()
  love.graphics.pop()
end

function module:contains(x,y)
  return self.fontH^2/dpiScale^2 > (self.x * size / dpiScale - x)^2 + (self.y * size /dpiScale - y)^2
end

names = {
['ad'] = '', --f641
['address-book'] = '', --f2b9
['address-card'] = '', --f2bb
['adjust'] = '', --f042
['air-freshener'] = '', --f5d0
['align-center'] = '', --f037
['align-justify'] = '', --f039
['align-left'] = '', --f036
['align-right'] = '', --f038
['allergies'] = '', --f461
['ambulance'] = '', --f0f9
['american-sign-language-interpreting'] = '', --f2a3
['anchor'] = '', --f13d
['angle-double-down'] = '', --f103
['angle-double-left'] = '', --f100
['angle-double-right'] = '', --f101
['angle-double-up'] = '', --f102
['angle-down'] = '', --f107
['angle-left'] = '', --f104
['angle-right'] = '', --f105
['angle-up'] = '', --f106
['angry'] = '', --f556
['ankh'] = '', --f644
['apple-alt'] = '', --f5d1
['archive'] = '', --f187
['archway'] = '', --f557
['arrow-alt-circle-down'] = '', --f358
['arrow-alt-circle-left'] = '', --f359
['arrow-alt-circle-right'] = '', --f35a
['arrow-alt-circle-up'] = '', --f35b
['arrow-circle-down'] = '', --f0ab
['arrow-circle-left'] = '', --f0a8
['arrow-circle-right'] = '', --f0a9
['arrow-circle-up'] = '', --f0aa
['arrow-down'] = '', --f063
['arrow-left'] = '', --f060
['arrow-right'] = '', --f061
['arrow-up'] = '', --f062
['arrows-alt'] = '', --f0b2
['arrows-alt-h'] = '', --f337
['arrows-alt-v'] = '', --f338
['assistive-listening-systems'] = '', --f2a2
['asterisk'] = '', --f069
['at'] = '', --f1fa
['atlas'] = '', --f558
['atom'] = '', --f5d2
['audio-description'] = '', --f29e
['award'] = '', --f559
['backspace'] = '', --f55a
['backward'] = '', --f04a
['balance-scale'] = '', --f24e
['ban'] = '', --f05e
['band-aid'] = '', --f462
['barcode'] = '', --f02a
['bars'] = '', --f0c9
['baseball-ball'] = '', --f433
['basketball-ball'] = '', --f434
['bath'] = '', --f2cd
['battery-empty'] = '', --f244
['battery-full'] = '', --f240
['battery-half'] = '', --f242
['battery-quarter'] = '', --f243
['battery-three-quarters'] = '', --f241
['bed'] = '', --f236
['beer'] = '', --f0fc
['bell'] = '', --f0f3
['bell-slash'] = '', --f1f6
['bezier-curve'] = '', --f55b
['bible'] = '', --f647
['bicycle'] = '', --f206
['binoculars'] = '', --f1e5
['birthday-cake'] = '', --f1fd
['blender'] = '', --f517
['blender-phone'] = '', --f6b6
['blind'] = '', --f29d
['bold'] = '', --f032
['bolt'] = '', --f0e7
['bomb'] = '', --f1e2
['bone'] = '', --f5d7
['bong'] = '', --f55c
['book'] = '', --f02d
['book-dead'] = '', --f6b7
['book-open'] = '', --f518
['book-reader'] = '', --f5da
['bookmark'] = '', --f02e
['bowling-ball'] = '', --f436
['box'] = '', --f466
['box-open'] = '', --f49e
['boxes'] = '', --f468
['braille'] = '', --f2a1
['brain'] = '', --f5dc
['briefcase'] = '', --f0b1
['briefcase-medical'] = '', --f469
['broadcast-tower'] = '', --f519
['broom'] = '', --f51a
['brush'] = '', --f55d
['bug'] = '', --f188
['building'] = '', --f1ad
['bullhorn'] = '', --f0a1
['bullseye'] = '', --f140
['burn'] = '', --f46a
['bus'] = '', --f207
['bus-alt'] = '', --f55e
['business-time'] = '', --f64a
['calculator'] = '', --f1ec
['calendar'] = '', --f133
['calendar-alt'] = '', --f073
['calendar-check'] = '', --f274
['calendar-minus'] = '', --f272
['calendar-plus'] = '', --f271
['calendar-times'] = '', --f273
['camera'] = '', --f030
['camera-retro'] = '', --f083
['campground'] = '', --f6bb
['cannabis'] = '', --f55f
['capsules'] = '', --f46b
['car'] = '', --f1b9
['car-alt'] = '', --f5de
['car-battery'] = '', --f5df
['car-crash'] = '', --f5e1
['car-side'] = '', --f5e4
['caret-down'] = '', --f0d7
['caret-left'] = '', --f0d9
['caret-right'] = '', --f0da
['caret-square-down'] = '', --f150
['caret-square-left'] = '', --f191
['caret-square-right'] = '', --f152
['caret-square-up'] = '', --f151
['caret-up'] = '', --f0d8
['cart-arrow-down'] = '', --f218
['cart-plus'] = '', --f217
['cat'] = '', --f6be
['certificate'] = '', --f0a3
['chair'] = '', --f6c0
['chalkboard'] = '', --f51b
['chalkboard-teacher'] = '', --f51c
['charging-station'] = '', --f5e7
['chart-area'] = '', --f1fe
['chart-bar'] = '', --f080
['chart-line'] = '', --f201
['chart-pie'] = '', --f200
['check'] = '', --f00c
['check-circle'] = '', --f058
['check-double'] = '', --f560
['check-square'] = '', --f14a
['chess'] = '', --f439
['chess-bishop'] = '', --f43a
['chess-board'] = '', --f43c
['chess-king'] = '', --f43f
['chess-knight'] = '', --f441
['chess-pawn'] = '', --f443
['chess-queen'] = '', --f445
['chess-rook'] = '', --f447
['chevron-circle-down'] = '', --f13a
['chevron-circle-left'] = '', --f137
['chevron-circle-right'] = '', --f138
['chevron-circle-up'] = '', --f139
['chevron-down'] = '', --f078
['chevron-left'] = '', --f053
['chevron-right'] = '', --f054
['chevron-up'] = '', --f077
['child'] = '', --f1ae
['church'] = '', --f51d
['circle'] = '', --f111
['circle-notch'] = '', --f1ce
['city'] = '', --f64f
['clipboard'] = '', --f328
['clipboard-check'] = '', --f46c
['clipboard-list'] = '', --f46d
['clock'] = '', --f017
['clone'] = '', --f24d
['closed-captioning'] = '', --f20a
['cloud'] = '', --f0c2
['cloud-download-alt'] = '', --f381
['cloud-meatball'] = '', --f73b
['cloud-moon'] = '', --f6c3
['cloud-moon-rain'] = '', --f73c
['cloud-rain'] = '', --f73d
['cloud-showers-heavy'] = '', --f740
['cloud-sun'] = '', --f6c4
['cloud-sun-rain'] = '', --f743
['cloud-upload-alt'] = '', --f382
['cocktail'] = '', --f561
['code'] = '', --f121
['code-branch'] = '', --f126
['coffee'] = '', --f0f4
['cog'] = '', --f013
['cogs'] = '', --f085
['coins'] = '', --f51e
['columns'] = '', --f0db
['comment'] = '', --f075
['comment-alt'] = '', --f27a
['comment-dollar'] = '', --f651
['comment-dots'] = '', --f4ad
['comment-slash'] = '', --f4b3
['comments'] = '', --f086
['comments-dollar'] = '', --f653
['compact-disc'] = '', --f51f
['compass'] = '', --f14e
['compress'] = '', --f066
['concierge-bell'] = '', --f562
['cookie'] = '', --f563
['cookie-bite'] = '', --f564
['copy'] = '', --f0c5
['copyright'] = '', --f1f9
['couch'] = '', --f4b8
['credit-card'] = '', --f09d
['crop'] = '', --f125
['crop-alt'] = '', --f565
['cross'] = '', --f654
['crosshairs'] = '', --f05b
['crow'] = '', --f520
['crown'] = '', --f521
['cube'] = '', --f1b2
['cubes'] = '', --f1b3
['cut'] = '', --f0c4
['database'] = '', --f1c0
['deaf'] = '', --f2a4
['democrat'] = '', --f747
['desktop'] = '', --f108
['dharmachakra'] = '', --f655
['diagnoses'] = '', --f470
['dice'] = '', --f522
['dice-d20'] = '', --f6cf
['dice-d6'] = '', --f6d1
['dice-five'] = '', --f523
['dice-four'] = '', --f524
['dice-one'] = '', --f525
['dice-six'] = '', --f526
['dice-three'] = '', --f527
['dice-two'] = '', --f528
['digital-tachograph'] = '', --f566
['directions'] = '', --f5eb
['divide'] = '', --f529
['dizzy'] = '', --f567
['dna'] = '', --f471
['dog'] = '', --f6d3
['dollar-sign'] = '', --f155
['dolly'] = '', --f472
['dolly-flatbed'] = '', --f474
['donate'] = '', --f4b9
['door-closed'] = '', --f52a
['door-open'] = '', --f52b
['dot-circle'] = '', --f192
['dove'] = '', --f4ba
['download'] = '', --f019
['drafting-compass'] = '', --f568
['dragon'] = '', --f6d5
['draw-polygon'] = '', --f5ee
['drum'] = '', --f569
['drum-steelpan'] = '', --f56a
['drumstick-bite'] = '', --f6d7
['dumbbell'] = '', --f44b
['dungeon'] = '', --f6d9
['edit'] = '', --f044
['eject'] = '', --f052
['ellipsis-h'] = '', --f141
['ellipsis-v'] = '', --f142
['envelope'] = '', --f0e0
['envelope-open'] = '', --f2b6
['envelope-open-text'] = '', --f658
['envelope-square'] = '', --f199
['equals'] = '', --f52c
['eraser'] = '', --f12d
['euro-sign'] = '', --f153
['exchange-alt'] = '', --f362
['exclamation'] = '', --f12a
['exclamation-circle'] = '', --f06a
['exclamation-triangle'] = '', --f071
['expand'] = '', --f065
['expand-arrows-alt'] = '', --f31e
['external-link-alt'] = '', --f35d
['external-link-square-alt'] = '', --f360
['eye'] = '', --f06e
['eye-dropper'] = '', --f1fb
['eye-slash'] = '', --f070
['fast-backward'] = '', --f049
['fast-forward'] = '', --f050
['fax'] = '', --f1ac
['feather'] = '', --f52d
['feather-alt'] = '', --f56b
['female'] = '', --f182
['fighter-jet'] = '', --f0fb
['file'] = '', --f15b
['file-alt'] = '', --f15c
['file-archive'] = '', --f1c6
['file-audio'] = '', --f1c7
['file-code'] = '', --f1c9
['file-contract'] = '', --f56c
['file-csv'] = '', --f6dd
['file-download'] = '', --f56d
['file-excel'] = '', --f1c3
['file-export'] = '', --f56e
['file-image'] = '', --f1c5
['file-import'] = '', --f56f
['file-invoice'] = '', --f570
['file-invoice-dollar'] = '', --f571
['file-medical'] = '', --f477
['file-medical-alt'] = '', --f478
['file-pdf'] = '', --f1c1
['file-powerpoint'] = '', --f1c4
['file-prescription'] = '', --f572
['file-signature'] = '', --f573
['file-upload'] = '', --f574
['file-video'] = '', --f1c8
['file-word'] = '', --f1c2
['fill'] = '', --f575
['fill-drip'] = '', --f576
['film'] = '', --f008
['filter'] = '', --f0b0
['fingerprint'] = '', --f577
['fire'] = '', --f06d
['fire-extinguisher'] = '', --f134
['first-aid'] = '', --f479
['fish'] = '', --f578
['fist-raised'] = '', --f6de
['flag'] = '', --f024
['flag-checkered'] = '', --f11e
['flag-usa'] = '', --f74d
['flask'] = '', --f0c3
['flushed'] = '', --f579
['folder'] = '', --f07b
['folder-minus'] = '', --f65d
['folder-open'] = '', --f07c
['folder-plus'] = '', --f65e
['font'] = '', --f031
['football-ball'] = '', --f44e
['forward'] = '', --f04e
['frog'] = '', --f52e
['frown'] = '', --f119
['frown-open'] = '', --f57a
['funnel-dollar'] = '', --f662
['futbol'] = '', --f1e3
['gamepad'] = '', --f11b
['gas-pump'] = '', --f52f
['gavel'] = '', --f0e3
['gem'] = '', --f3a5
['genderless'] = '', --f22d
['ghost'] = '', --f6e2
['gift'] = '', --f06b
['glass-martini'] = '', --f000
['glass-martini-alt'] = '', --f57b
['glasses'] = '', --f530
['globe'] = '', --f0ac
['globe-africa'] = '', --f57c
['globe-americas'] = '', --f57d
['globe-asia'] = '', --f57e
['golf-ball'] = '', --f450
['gopuram'] = '', --f664
['graduation-cap'] = '', --f19d
['greater-than'] = '', --f531
['greater-than-equal'] = '', --f532
['grimace'] = '', --f57f
['grin'] = '', --f580
['grin-alt'] = '', --f581
['grin-beam'] = '', --f582
['grin-beam-sweat'] = '', --f583
['grin-hearts'] = '', --f584
['grin-squint'] = '', --f585
['grin-squint-tears'] = '', --f586
['grin-stars'] = '', --f587
['grin-tears'] = '', --f588
['grin-tongue'] = '', --f589
['grin-tongue-squint'] = '', --f58a
['grin-tongue-wink'] = '', --f58b
['grin-wink'] = '', --f58c
['grip-horizontal'] = '', --f58d
['grip-vertical'] = '', --f58e
['h-square'] = '', --f0fd
['hammer'] = '', --f6e3
['hamsa'] = '', --f665
['hand-holding'] = '', --f4bd
['hand-holding-heart'] = '', --f4be
['hand-holding-usd'] = '', --f4c0
['hand-lizard'] = '', --f258
['hand-paper'] = '', --f256
['hand-peace'] = '', --f25b
['hand-point-down'] = '', --f0a7
['hand-point-left'] = '', --f0a5
['hand-point-right'] = '', --f0a4
['hand-point-up'] = '', --f0a6
['hand-pointer'] = '', --f25a
['hand-rock'] = '', --f255
['hand-scissors'] = '', --f257
['hand-spock'] = '', --f259
['hands'] = '', --f4c2
['hands-helping'] = '', --f4c4
['handshake'] = '', --f2b5
['hanukiah'] = '', --f6e6
['hashtag'] = '', --f292
['hat-wizard'] = '', --f6e8
['haykal'] = '', --f666
['hdd'] = '', --f0a0
['heading'] = '', --f1dc
['headphones'] = '', --f025
['headphones-alt'] = '', --f58f
['headset'] = '', --f590
['heart'] = '', --f004
['heartbeat'] = '', --f21e
['helicopter'] = '', --f533
['highlighter'] = '', --f591
['hiking'] = '', --f6ec
['hippo'] = '', --f6ed
['history'] = '', --f1da
['hockey-puck'] = '', --f453
['home'] = '', --f015
['horse'] = '', --f6f0
['hospital'] = '', --f0f8
['hospital-alt'] = '', --f47d
['hospital-symbol'] = '', --f47e
['hot-tub'] = '', --f593
['hotel'] = '', --f594
['hourglass'] = '', --f254
['hourglass-end'] = '', --f253
['hourglass-half'] = '', --f252
['hourglass-start'] = '', --f251
['house-damage'] = '', --f6f1
['hryvnia'] = '', --f6f2
['i-cursor'] = '', --f246
['id-badge'] = '', --f2c1
['id-card'] = '', --f2c2
['id-card-alt'] = '', --f47f
['image'] = '', --f03e
['images'] = '', --f302
['inbox'] = '', --f01c
['indent'] = '', --f03c
['industry'] = '', --f275
['infinity'] = '', --f534
['info'] = '', --f129
['info-circle'] = '', --f05a
['italic'] = '', --f033
['jedi'] = '', --f669
['joint'] = '', --f595
['journal-whills'] = '', --f66a
['kaaba'] = '', --f66b
['key'] = '', --f084
['keyboard'] = '', --f11c
['khanda'] = '', --f66d
['kiss'] = '', --f596
['kiss-beam'] = '', --f597
['kiss-wink-heart'] = '', --f598
['kiwi-bird'] = '', --f535
['landmark'] = '', --f66f
['language'] = '', --f1ab
['laptop'] = '', --f109
['laptop-code'] = '', --f5fc
['laugh'] = '', --f599
['laugh-beam'] = '', --f59a
['laugh-squint'] = '', --f59b
['laugh-wink'] = '', --f59c
['layer-group'] = '', --f5fd
['leaf'] = '', --f06c
['lemon'] = '', --f094
['less-than'] = '', --f536
['less-than-equal'] = '', --f537
['level-down-alt'] = '', --f3be
['level-up-alt'] = '', --f3bf
['life-ring'] = '', --f1cd
['lightbulb'] = '', --f0eb
['link'] = '', --f0c1
['lira-sign'] = '', --f195
['list'] = '', --f03a
['list-alt'] = '', --f022
['list-ol'] = '', --f0cb
['list-ul'] = '', --f0ca
['location-arrow'] = '', --f124
['lock'] = '', --f023
['lock-open'] = '', --f3c1
['long-arrow-alt-down'] = '', --f309
['long-arrow-alt-left'] = '', --f30a
['long-arrow-alt-right'] = '', --f30b
['long-arrow-alt-up'] = '', --f30c
['low-vision'] = '', --f2a8
['luggage-cart'] = '', --f59d
['magic'] = '', --f0d0
['magnet'] = '', --f076
['mail-bulk'] = '', --f674
['male'] = '', --f183
['map'] = '', --f279
['map-marked'] = '', --f59f
['map-marked-alt'] = '', --f5a0
['map-marker'] = '', --f041
['map-marker-alt'] = '', --f3c5
['map-pin'] = '', --f276
['map-signs'] = '', --f277
['marker'] = '', --f5a1
['mars'] = '', --f222
['mars-double'] = '', --f227
['mars-stroke'] = '', --f229
['mars-stroke-h'] = '', --f22b
['mars-stroke-v'] = '', --f22a
['mask'] = '', --f6fa
['medal'] = '', --f5a2
['medkit'] = '', --f0fa
['meh'] = '', --f11a
['meh-blank'] = '', --f5a4
['meh-rolling-eyes'] = '', --f5a5
['memory'] = '', --f538
['menorah'] = '', --f676
['mercury'] = '', --f223
['meteor'] = '', --f753
['microchip'] = '', --f2db
['microphone'] = '', --f130
['microphone-alt'] = '', --f3c9
['microphone-alt-slash'] = '', --f539
['microphone-slash'] = '', --f131
['microscope'] = '', --f610
['minus'] = '', --f068
['minus-circle'] = '', --f056
['minus-square'] = '', --f146
['mobile'] = '', --f10b
['mobile-alt'] = '', --f3cd
['money-bill'] = '', --f0d6
['money-bill-alt'] = '', --f3d1
['money-bill-wave'] = '', --f53a
['money-bill-wave-alt'] = '', --f53b
['money-check'] = '', --f53c
['money-check-alt'] = '', --f53d
['monument'] = '', --f5a6
['moon'] = '', --f186
['mortar-pestle'] = '', --f5a7
['mosque'] = '', --f678
['motorcycle'] = '', --f21c
['mountain'] = '', --f6fc
['mouse-pointer'] = '', --f245
['music'] = '', --f001
['network-wired'] = '', --f6ff
['neuter'] = '', --f22c
['newspaper'] = '', --f1ea
['not-equal'] = '', --f53e
['notes-medical'] = '', --f481
['object-group'] = '', --f247
['object-ungroup'] = '', --f248
['oil-can'] = '', --f613
['om'] = '', --f679
['otter'] = '', --f700
['outdent'] = '', --f03b
['paint-brush'] = '', --f1fc
['paint-roller'] = '', --f5aa
['palette'] = '', --f53f
['pallet'] = '', --f482
['paper-plane'] = '', --f1d8
['paperclip'] = '', --f0c6
['parachute-box'] = '', --f4cd
['paragraph'] = '', --f1dd
['parking'] = '', --f540
['passport'] = '', --f5ab
['pastafarianism'] = '', --f67b
['paste'] = '', --f0ea
['pause'] = '', --f04c
['pause-circle'] = '', --f28b
['paw'] = '', --f1b0
['peace'] = '', --f67c
['pen'] = '', --f304
['pen-alt'] = '', --f305
['pen-fancy'] = '', --f5ac
['pen-nib'] = '', --f5ad
['pen-square'] = '', --f14b
['pencil-alt'] = '', --f303
['pencil-ruler'] = '', --f5ae
['people-carry'] = '', --f4ce
['percent'] = '', --f295
['percentage'] = '', --f541
['person-booth'] = '', --f756
['phone'] = '', --f095
['phone-slash'] = '', --f3dd
['phone-square'] = '', --f098
['phone-volume'] = '', --f2a0
['piggy-bank'] = '', --f4d3
['pills'] = '', --f484
['place-of-worship'] = '', --f67f
['plane'] = '', --f072
['plane-arrival'] = '', --f5af
['plane-departure'] = '', --f5b0
['play'] = '', --f04b
['play-circle'] = '', --f144
['plug'] = '', --f1e6
['plus'] = '', --f067
['plus-circle'] = '', --f055
['plus-square'] = '', --f0fe
['podcast'] = '', --f2ce
['poll'] = '', --f681
['poll-h'] = '', --f682
['poo'] = '', --f2fe
['poo-storm'] = '', --f75a
['poop'] = '', --f619
['portrait'] = '', --f3e0
['pound-sign'] = '', --f154
['power-off'] = '', --f011
['pray'] = '', --f683
['praying-hands'] = '', --f684
['prescription'] = '', --f5b1
['prescription-bottle'] = '', --f485
['prescription-bottle-alt'] = '', --f486
['print'] = '', --f02f
['procedures'] = '', --f487
['project-diagram'] = '', --f542
['puzzle-piece'] = '', --f12e
['qrcode'] = '', --f029
['question'] = '', --f128
['question-circle'] = '', --f059
['quidditch'] = '', --f458
['quote-left'] = '', --f10d
['quote-right'] = '', --f10e
['quran'] = '', --f687
['rainbow'] = '', --f75b
['random'] = '', --f074
['receipt'] = '', --f543
['recycle'] = '', --f1b8
['redo'] = '', --f01e
['redo-alt'] = '', --f2f9
['registered'] = '', --f25d
['reply'] = '', --f3e5
['reply-all'] = '', --f122
['republican'] = '', --f75e
['retweet'] = '', --f079
['ribbon'] = '', --f4d6
['ring'] = '', --f70b
['road'] = '', --f018
['robot'] = '', --f544
['rocket'] = '', --f135
['route'] = '', --f4d7
['rss'] = '', --f09e
['rss-square'] = '', --f143
['ruble-sign'] = '', --f158
['ruler'] = '', --f545
['ruler-combined'] = '', --f546
['ruler-horizontal'] = '', --f547
['ruler-vertical'] = '', --f548
['running'] = '', --f70c
['rupee-sign'] = '', --f156
['sad-cry'] = '', --f5b3
['sad-tear'] = '', --f5b4
['save'] = '', --f0c7
['school'] = '', --f549
['screwdriver'] = '', --f54a
['scroll'] = '', --f70e
['search'] = '', --f002
['search-dollar'] = '', --f688
['search-location'] = '', --f689
['search-minus'] = '', --f010
['search-plus'] = '', --f00e
['seedling'] = '', --f4d8
['server'] = '', --f233
['shapes'] = '', --f61f
['share'] = '', --f064
['share-alt'] = '', --f1e0
['share-alt-square'] = '', --f1e1
['share-square'] = '', --f14d
['shekel-sign'] = '', --f20b
['shield-alt'] = '', --f3ed
['ship'] = '', --f21a
['shipping-fast'] = '', --f48b
['shoe-prints'] = '', --f54b
['shopping-bag'] = '', --f290
['shopping-basket'] = '', --f291
['shopping-cart'] = '', --f07a
['shower'] = '', --f2cc
['shuttle-van'] = '', --f5b6
['sign'] = '', --f4d9
['sign-in-alt'] = '', --f2f6
['sign-language'] = '', --f2a7
['sign-out-alt'] = '', --f2f5
['signal'] = '', --f012
['signature'] = '', --f5b7
['sitemap'] = '', --f0e8
['skull'] = '', --f54c
['skull-crossbones'] = '', --f714
['slash'] = '', --f715
['sliders-h'] = '', --f1de
['smile'] = '', --f118
['smile-beam'] = '', --f5b8
['smile-wink'] = '', --f4da
['smog'] = '', --f75f
['smoking'] = '', --f48d
['smoking-ban'] = '', --f54d
['snowflake'] = '', --f2dc
['socks'] = '', --f696
['solar-panel'] = '', --f5ba
['sort'] = '', --f0dc
['sort-alpha-down'] = '', --f15d
['sort-alpha-up'] = '', --f15e
['sort-amount-down'] = '', --f160
['sort-amount-up'] = '', --f161
['sort-down'] = '', --f0dd
['sort-numeric-down'] = '', --f162
['sort-numeric-up'] = '', --f163
['sort-up'] = '', --f0de
['spa'] = '', --f5bb
['space-shuttle'] = '', --f197
['spider'] = '', --f717
['spinner'] = '', --f110
['splotch'] = '', --f5bc
['spray-can'] = '', --f5bd
['square'] = '', --f0c8
['square-full'] = '', --f45c
['square-root-alt'] = '', --f698
['stamp'] = '', --f5bf
['star'] = '', --f005
['star-and-crescent'] = '', --f699
['star-half'] = '', --f089
['star-half-alt'] = '', --f5c0
['star-of-david'] = '', --f69a
['star-of-life'] = '', --f621
['step-backward'] = '', --f048
['step-forward'] = '', --f051
['stethoscope'] = '', --f0f1
['sticky-note'] = '', --f249
['stop'] = '', --f04d
['stop-circle'] = '', --f28d
['stopwatch'] = '', --f2f2
['store'] = '', --f54e
['store-alt'] = '', --f54f
['stream'] = '', --f550
['street-view'] = '', --f21d
['strikethrough'] = '', --f0cc
['stroopwafel'] = '', --f551
['subscript'] = '', --f12c
['subway'] = '', --f239
['suitcase'] = '', --f0f2
['suitcase-rolling'] = '', --f5c1
['sun'] = '', --f185
['superscript'] = '', --f12b
['surprise'] = '', --f5c2
['swatchbook'] = '', --f5c3
['swimmer'] = '', --f5c4
['swimming-pool'] = '', --f5c5
['synagogue'] = '', --f69b
['sync'] = '', --f021
['sync-alt'] = '', --f2f1
['syringe'] = '', --f48e
['table'] = '', --f0ce
['table-tennis'] = '', --f45d
['tablet'] = '', --f10a
['tablet-alt'] = '', --f3fa
['tablets'] = '', --f490
['tachometer-alt'] = '', --f3fd
['tag'] = '', --f02b
['tags'] = '', --f02c
['tape'] = '', --f4db
['tasks'] = '', --f0ae
['taxi'] = '', --f1ba
['teeth'] = '', --f62e
['teeth-open'] = '', --f62f
['temperature-high'] = '', --f769
['temperature-low'] = '', --f76b
['terminal'] = '', --f120
['text-height'] = '', --f034
['text-width'] = '', --f035
['th'] = '', --f00a
['th-large'] = '', --f009
['th-list'] = '', --f00b
['theater-masks'] = '', --f630
['thermometer'] = '', --f491
['thermometer-empty'] = '', --f2cb
['thermometer-full'] = '', --f2c7
['thermometer-half'] = '', --f2c9
['thermometer-quarter'] = '', --f2ca
['thermometer-three-quarters'] = '', --f2c8
['thumbs-down'] = '', --f165
['thumbs-up'] = '', --f164
['thumbtack'] = '', --f08d
['ticket-alt'] = '', --f3ff
['times'] = '', --f00d
['times-circle'] = '', --f057
['tint'] = '', --f043
['tint-slash'] = '', --f5c7
['tired'] = '', --f5c8
['toggle-off'] = '', --f204
['toggle-on'] = '', --f205
['toilet-paper'] = '', --f71e
['toolbox'] = '', --f552
['tooth'] = '', --f5c9
['torah'] = '', --f6a0
['torii-gate'] = '', --f6a1
['tractor'] = '', --f722
['trademark'] = '', --f25c
['traffic-light'] = '', --f637
['train'] = '', --f238
['transgender'] = '', --f224
['transgender-alt'] = '', --f225
['trash'] = '', --f1f8
['trash-alt'] = '', --f2ed
['tree'] = '', --f1bb
['trophy'] = '', --f091
['truck'] = '', --f0d1
['truck-loading'] = '', --f4de
['truck-monster'] = '', --f63b
['truck-moving'] = '', --f4df
['truck-pickup'] = '', --f63c
['tshirt'] = '', --f553
['tty'] = '', --f1e4
['tv'] = '', --f26c
['umbrella'] = '', --f0e9
['umbrella-beach'] = '', --f5ca
['underline'] = '', --f0cd
['undo'] = '', --f0e2
['undo-alt'] = '', --f2ea
['universal-access'] = '', --f29a
['university'] = '', --f19c
['unlink'] = '', --f127
['unlock'] = '', --f09c
['unlock-alt'] = '', --f13e
['upload'] = '', --f093
['user'] = '', --f007
['user-alt'] = '', --f406
['user-alt-slash'] = '', --f4fa
['user-astronaut'] = '', --f4fb
['user-check'] = '', --f4fc
['user-circle'] = '', --f2bd
['user-clock'] = '', --f4fd
['user-cog'] = '', --f4fe
['user-edit'] = '', --f4ff
['user-friends'] = '', --f500
['user-graduate'] = '', --f501
['user-injured'] = '', --f728
['user-lock'] = '', --f502
['user-md'] = '', --f0f0
['user-minus'] = '', --f503
['user-ninja'] = '', --f504
['user-plus'] = '', --f234
['user-secret'] = '', --f21b
['user-shield'] = '', --f505
['user-slash'] = '', --f506
['user-tag'] = '', --f507
['user-tie'] = '', --f508
['user-times'] = '', --f235
['users'] = '', --f0c0
['users-cog'] = '', --f509
['utensil-spoon'] = '', --f2e5
['utensils'] = '', --f2e7
['vector-square'] = '', --f5cb
['venus'] = '', --f221
['venus-double'] = '', --f226
['venus-mars'] = '', --f228
['vial'] = '', --f492
['vials'] = '', --f493
['video'] = '', --f03d
['video-slash'] = '', --f4e2
['vihara'] = '', --f6a7
['volleyball-ball'] = '', --f45f
['volume-down'] = '', --f027
['volume-mute'] = '', --f6a9
['volume-off'] = '', --f026
['volume-up'] = '', --f028
['vote-yea'] = '', --f772
['vr-cardboard'] = '', --f729
['walking'] = '', --f554
['wallet'] = '', --f555
['warehouse'] = '', --f494
['water'] = '', --f773
['weight'] = '', --f496
['weight-hanging'] = '', --f5cd
['wheelchair'] = '', --f193
['wifi'] = '', --f1eb
['wind'] = '', --f72e
['window-close'] = '', --f410
['window-maximize'] = '', --f2d0
['window-minimize'] = '', --f2d1
['window-restore'] = '', --f2d2
['wine-bottle'] = '', --f72f
['wine-glass'] = '', --f4e3
['wine-glass-alt'] = '', --f5ce
['won-sign'] = '', --f159
['wrench'] = '', --f0ad
['x-ray'] = '', --f497
['yen-sign'] = '', --f157
['yin-yang'] = '', --f6ad
}
names.exit     = names['door-open']
names.tree     = names['project-diagram']
names.edge     = names['window-maximize']
names.simplex  = names['cloud']
names.position = names['expand-arrows-alt']
names.wrap     = names['circle-notch']
names.negate   = names['adjust']
names.clip     = names['moon']
names.combine  = names['layer-group']
names.sum      = names['plus-circle']
names.tint     = names['palette']  -- note: overriding existing icon
names.memo     = names['chess-board']
names.mirror   = names['book-open']
names.interact = names['hand-point-up']
names.snip     = names['chevron-circle-left']

names.swap     = names['sync-alt']
names.add      = names['plus-square']
names.del      = names['minus-square']
names.store    = names['download'] -- note: overriding existing icon
names.load     = names['upload']
names.next     = names['angle-double-right']
return module