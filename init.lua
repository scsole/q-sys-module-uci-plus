local json = require("rapidjson")

local Module = {}

--------------------------------Layer Groups and Controllers-----------------------------------------------
Module.Layer = {}
Module.Layer.__index = Module.Layer


--- Create a layer object.
-- name is the UCI layer name.
-- stateFunction is a function which should return a boolean value, which a LayerController will run to update the
-- visibility.
-- transition is the desired transition if not 'none'
function Module.Layer.New(name, stateFunction, transition)
  local self = {}

  self.Name = name
  self.State = stateFunction or function()
    return true
  end
  self.Transition = transition or "none"

  setmetatable(self, Module.Layer)
  return self
end

Module.LayerController = {}
Module.LayerController.__index = Module.LayerController

-- add Layer objects to this controller

-- runs on a layer object to update its visibility. Set hide to true to override Layer's stateFunction
function Module.LayerController:Update(layer, hide)
  local newState = layer.State() and not hide

  if newState ~= layer.PreviousState then
    Uci.SetLayerVisibility(self.Page, layer.Name, newState, layer.Transition)
    if self.Debug then
      print("LayerControllerUpdate:", layer.Name, 'New State = ' .. tostring(newState))
    end
  end

  layer.PreviousState = newState

end

function Module.LayerController:UpdateAll(hide)
  for _, layer in pairs(self.List) do
    self:Update(layer, hide)
  end
end

-- hides all Layers in the Controller
function Module.LayerController:Hide()
  self:UpdateAll(true)
end

-- returns the state of another layer and updates it.
function Module.LayerController:GetState(layername)
  for _, layer in pairs(self.List) do
    if layer.Name == layername then
      self:Update(layer)
      return layer.State()
    end
  end
end

function Module.LayerController:Add(layer)
  if self.Debug then
    print("Layer added:", layer.Name)
  end
  table.insert(self.List, layer)
  self:Update(layer)
end

function Module.LayerController:UpdateOnEvent(control)
  local oldEH = control.EventHandler or function()
  end
  control.EventHandler = function(ctrl)
    oldEH(ctrl)
    self:UpdateAll()
  end
end

-- set .Debug to true if you want to see a print of what is happening.
function Module.LayerController.New(page, list)
  local self = {}

  self.Page = page or "Page 1"
  self.List = list or {}
  self.Debug = false
  setmetatable(self, Module.LayerController)

  return self
end

----------------------------------------------------------------------------------------

-- Load UCI Information / UCI Names
function Module.GetLayout(UCIName) -- Load UCI information into table to parse below
  local thefile = io.open("design/ucis.json")
  local text = thefile:read("a")
  local UCIs = json.decode(text).Ucis
  thefile:close()

  for _, UCI in pairs(UCIs) do
    if UCI.Name == UCIName then
      return UCI.Pages
    end
  end
end

---------------------------------------------------------------
-- add standard Uci library to this library
for key, fun in pairs(Uci) do
  Module[key] = fun
end

return Module
