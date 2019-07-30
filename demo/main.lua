local group
local lb = require 'lovebuttons'

local function buttonClick(button)
  print(button.info.id)
end

local function buttonEnter(button)
  button.info.hovered = true
end

local function buttonLeave(button)
  button.info.hovered = false
end

local function buttonDraw(button)
  local c = {love.graphics.getColor()}
  love.graphics.setColor(button.info.colors[button.info.hovered])
  love.graphics.rectangle('fill', button.x, button.y, button.w, button.h)
  love.graphics.setColor(c)
end

function love.load()
  group = lb.new()
  group:add(
    100, 100,
    200, 200,
    {
      colors={
        [false] = {0.2, 0.2, 0.2, 1},
        [true] = {0.5, 0, 0, 1}
      },
      hovered = false,
      id = 1
    },
    buttonClick,
    buttonEnter,
    buttonLeave,
    buttonDraw
  )
  group:add(
    180, 150,
    200, 200,
    {
      colors={
        [false] = {0.5, 0.5, 0.5, 1},
        [true] = {0.3, 0.3, 0.8, 1}
      },
      hovered = false,
      id = 2
    },
    buttonClick,
    buttonEnter,
    buttonLeave,
    buttonDraw
  )
end

function love.update(dt)
  if not x and love.keyboard.isDown('space') then
    love.mouse.setPosition(150, 150)
  end
  group:update()
end

function love.draw()
  group:draw()
  love.graphics.print(love.timer.getFPS())
end