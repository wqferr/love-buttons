local ButtonGroup = {}
local ButtonGroupMt = {__index = ButtonGroup}

-- TODO group-default onEnter and onLeave

local function nop() end
local mouseWasDown = false

local function between(a, minA, maxA)
  return a >= minA and a <= maxA
end

local function within(x, y, button)
  return (
    between(x, button.x, button.x + button.w)
    and between(y, button.y, button.y + button.h)
  )
end

local function updateMouseStatus()
  local mouseIsDown = love.mouse.isDown()
  local clicked = mouseIsDown and not mouseWasDown
  mouseWasDown = mouseIsDown

  return clicked
end

local function assertButtonArgs(x, y, w, h)
  assert(x and y and w and h, 'Must provide coordinates and dimensions')
  assert(w > 0 and h > 0, 'Width and height must be positive')
  assert(w % 1 == 0 and h % 1 == 0, 'Width and height must be integers')
end

local function findCurrentlyHoveredButton(buttonGroup, mouseX, mouseY)
  for idx = #buttonGroup, 1, -1 do
    local button = buttonGroup[idx]
    if within(mouseX, mouseY, button) then
      return button
    end
  end
end

local function updateHovered(buttonGroup, newHovered)
  if newHovered ~= buttonGroup.hovered then
    if buttonGroup.hovered then
      buttonGroup.hovered:onLeave()
    end
    buttonGroup.hovered = newHovered
    if buttonGroup.hovered then
      buttonGroup.hovered:onEnter()
    end
  end
end

function ButtonGroup.new()
  return setmetatable({}, ButtonGroupMt)
end

function ButtonGroup:add(x, y, w, h, onClick, onEnter, onLeave, id)
  --[[
  Adds a new button to a button group.
  Buttons added later take priority when checking for a coordinate. One can
  think of them as being "on top" and blocking the ones inserted before it.
  ]]
  assertButtonArgs(x, y, w, h)

  local button = {
    x = x,
    y = y,
    w = w,
    h = h,
    onClick = onClick or nop,
    onEnter = onEnter or nop,
    onLeave = onLeave or nop,
    id = id
  }
  table.insert(self, button)
end

function ButtonGroup:update()
  local mouseX, mouseY = love.mouse.getPosition()
  local newHovered = findCurrentlyHoveredButton(self, mouseX, mouseY)
  updateHovered(self, newHovered)
  local clicked = updateMouseStatus()

  if clicked then
    self.hovered:onClick()
  end
end

setmetatable(ButtonGroup, {__call = ButtonGroup.new})
return ButtonGroup