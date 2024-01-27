local json = require("rapidjson")

local Module = {}

--------------------------------Layer Groups and Controllers-----------------------------------------------

Module.Layer = {}
Module.Layer.__index = Module.Layer

--- Create a layer object.
--- @param name string The UCI layer name.
--- @param stateFunction function Function which returns a boolean value corresponding to the the layer's visibility.
--- @param transition string? The desired transition if not inheriting the controller's default.
--- @return table
function Module.Layer.New(name, stateFunction, transition)
  local self = {}

  self.Name = name
  self.State = stateFunction or function()
    return true
  end
  self.Transition = transition

  setmetatable(self, Module.Layer)
  return self
end

Module.LayerController = {}
Module.LayerController.__index = Module.LayerController

--- Update a layer's visibility. Optionally set hide to true to override a layer's `stateFunction` and hide the layer.
--- @param layer table The layer object to update visibility for.
--- @param hide boolean? Optionally set to true when a layer's stateFunction should be overridden.
function Module.LayerController:Update(layer, hide)
  local newState = layer.State() and not hide

  if newState ~= layer.PreviousState then
    Uci.SetLayerVisibility(self.Page, layer.Name, newState, layer.Transition or self.DefaultTransition)
    if self.Debug then
      print("LayerControllerUpdate:", layer.Name, 'New State = ', tostring(newState))
    end
  end

  layer.PreviousState = newState
end

--- Update the visibility of all layers in the layer controller.
--- @param hide boolean? Optionally set to true to override all stateFunctions and hide all layers.
function Module.LayerController:UpdateAll(hide)
  for _, layer in pairs(self.List) do
    self:Update(layer, hide)
  end
end

--- Hide all layers in the Controller.
function Module.LayerController:Hide()
  self:UpdateAll(true)
end

--- Return the state of another layer and update it.
--- @param layerName string The name of the layer to get stat from.
--- @return boolean? The state of the layer if it exists, else nil.
function Module.LayerController:GetState(layerName)
  for _, layer in pairs(self.List) do
    if layer.Name == layerName then
      self:Update(layer)
      return layer.State()
    end
  end
end

--- Add layer objects to this controller.
--- @param layer table The layer object to add.
function Module.LayerController:Add(layer)
  if self.Debug then
    print("Layer added:", layer.Name)
  end
  table.insert(self.List, layer)
  self:Update(layer)
end

--- Initialize this controller's layer list using a boolean lookup table. The lookup table's keys must match layer names
--- while the value must be a boolean type corresponding to the visibility.
--- @param layerLookup table Table containing key value pairs
--- @param transition string? The desired transition for all layers if not the controller's default
function Module.LayerController:InitializeList(layerLookup, transition)
  if self.Debug then
    print("LayerController: Initialize List from lookup table")
  end
  self.List = {}
  for layer, _boolValue in pairs(layerLookup) do
    self:Add(
      Module.Layer.New(
        layer,
        function() return layerLookup[layer] end,
        transition
      ))
  end
end

--- Modify a controls event handler so that it also triggers the layer controller to update visibilities of all layers.
--- @param control table A control which should also trigger visibility checks.
function Module.LayerController:UpdateOnEvent(control)
  local oldEH = control.EventHandler or function()
  end
  control.EventHandler = function(ctrl)
    oldEH(ctrl)
    self:UpdateAll()
  end
end

--- Create a new layer controller object. Set .Debug to true if you want to see a print of what is happening.
--- @param page string? The UCI page name that this layer controller should act on. Defaults to "Page 1".
--- @param list table? An optional list of layer objects.
--- @param transition string? An optional default transition to use when layers do not specify a transition.
--- @return table # A new layer controller object.
function Module.LayerController.New(page, list, transition)
  local self = {}

  self.Page = page or "Page 1"
  self.List = list or {}
  self.Debug = false
  self.DefaultTransition = transition or "none"
  setmetatable(self, Module.LayerController)

  return self
end

----------------------------------------------------------------------------------------

--- Load UCI Information / UCI Names.
---@param UCIName string The UCI name to get the layout for.
---@return table? # A list of pages contained in the UCI.
function Module.GetLayout(UCIName)
  -- Load UCI information into table to parse below
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

-- Add the standard Uci library interface to this library
for key, fun in pairs(Uci) do
  Module[key] = fun
end

return Module
