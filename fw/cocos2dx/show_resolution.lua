

-- @see https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
-- @see https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html
-- points Drawing API are measured by points
-- rendered pixel

local iphone = {
  {name = 'iphone2g',           points = {320, 480},    scale = 1},
  {name = 'iphone3g',           points = {320, 480},    scale = 1},
  {name = 'iphone3gs',          points = {320, 480},    scale = 1},

  {name = 'iphone4',            points = {320, 480},    scale = 2},
  {name = 'iphone4s',           points = {320, 480},    scale = 2},

  {name = 'iphone5',            points = {320, 568},    scale = 2},
  {name = 'iphone5s',           points = {320, 568},    scale = 2},
  {name = 'iphone5c',           points = {320, 568},    scale = 2},
  {name = 'iphoneSE',           points = {320, 568},    scale = 2},

  {name = 'iphone6',            points = {375, 667},    scale = 2},
  {name = 'iphone6s',           points = {375, 667},    scale = 2},
  {name = 'iphone7',            points = {375, 667},    scale = 2},
  {name = 'iphone8',            points = {375, 667},    scale = 2},

  {name = 'iphone6+',           points = {414, 736},    scale = 3},
  {name = 'iphone6s+',          points = {414, 736},    scale = 3},
  {name = 'iphone7+',           points = {414, 736},    scale = 3},
  {name = 'iphone8+',           points = {414, 736},    scale = 3},

  {name = 'iphoneX',            points = {375, 812},    scale = 3},
  {name = 'iphoneXs',           points = {375, 812},    scale = 3},

  {name = 'iphoneXr',           points = {414, 896},    scale = 2},

  {name = 'iphoneXsMax',        points = {414, 896},    scale = 3},

  {name = 'ipad',               points = {768, 1024},   scale = 1},
  {name = 'ipad mini 4',        points = {768, 1024},   scale = 2},
  {name = 'ipad air 2',         points = {768, 1024},   scale = 2},
  {name = 'ipad pro(9.7 inch)', points = {768, 1024},   scale = 2},

  {name = 'ipad pro(12.9inch)', points = {1024, 1336},  scale = 2},

  {name = 'ipad pro(10.5inch)', points = {834, 1112},   scale = 2}
}

local function highest_common_divisor(a, b)
  local min, max = a, b
  if min > max then
    min, max = b, a
  end

  assert(min > 0)

  local divisor = max % min
  while divisor >0 do
    max = min
    min = divisor

    divisor = max % min
  end

  return min
end

-- local design_width = 750
-- local design_height = 1334
local design_width = 1080
local design_height = 1920
local design_wh_ratio = design_width / design_height

for _, v in ipairs(iphone) do
  v.pixels = {v.points[1] * v.scale, v.points[2] * v.scale}
  local divisor = highest_common_divisor(v.points[2], v.points[1])
  v.ratio = {v.points[1] / divisor, v.points[2]/ divisor}

  local wh_ratio = v.points[1] / v.points[2]
  if wh_ratio > design_wh_ratio then
    v.design = {math.floor(v.points[1] * design_height / v.points[2]), design_height}
  else
    v.design = {design_width, math.floor(v.points[2] * design_width / v.points[1])}
  end
end

print(string.format('%-25s%-13s %-6s %-13s %-7s %10s %10s %-13s', 'name', 'points', 'scale', 'pixels', 'ratio', 'w-h', 'h-w', 'real-design'))
for _, v in ipairs(iphone) do
  print(string.format('%-25s{%-4d * %-4d} %-6d {%-4d * %-4d} %3d:%-3d %10.2f %10.2f {%-4d * %-4d}',
          v.name,
          v.points[1], v.points[2],
          v.scale,
          v.pixels[1], v.pixels[2],
          v.ratio[1], v.ratio[2],
          v.points[1]/v.points[2],
          v.points[2]/v.points[1],
          v.design[1], v.design[2]))
end
