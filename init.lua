json = require("rapidjson")

Module = {}

--------------------------------Layer Groups and Controllers-----------------------------------------------
Layer = {}

-- create a layer object
-- name is the UCI layer name
-- stateFunction is a function which should return a boolean value, which a LayerController will run to update the visibility.
-- transition is the desired trainsition if not 'none'
function Layer:New(name, stateFunction, transition)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.Name = name
    o.State = stateFunction or function()
            return true
        end
    o.Transition = transition or "none"
    return o
end

LayerController = {}

-- add Layer objects to this controller

-- runs on a layer object to update its visibility. Set hide to true to override Layer's stateFunction
function LayerController:Update(layer, hide)
    local state = layer.State() and not hide
    if self.Debug then
        print("LayerControllerUpdate:", layer.Name, state)
    end
    Uci.SetLayerVisibility(self.Page, layer.Name, state, layer.Transition)
end

function LayerController:UpdateAll(hide)
    if self.Debug then
        print("LayerController UpdateAll: hide =", false)
    end
    for _, layer in pairs(self.List) do
        self:Update(layer, hide)
    end
end

-- hides all Layers in the Controller
function LayerController:Hide()
    self:UpdateAll(true)
end

-- returns the state of another layer and updates it.
function LayerController:GetState(layername)
    for _, layer in pairs(self.List) do
        if layer.Name == layername then
            self:Update(layer)
            return layer.State()
        end
    end
end

function LayerController:Add(layer)
    if self.Debug then
        print("Add:", layer.Name)
    end
    table.insert(self.List, layer)
    self:Update(layer)
end

function LayerController:UpdateOnEvent(control)
    local oldEH = control.EventHandler or function()
        end
    control.EventHandler = function(ctrl)
        oldEH(ctrl)
        self:UpdateAll()
    end
end

-- set .Debug to true if you want to see a print of what is happening.
function LayerController:New(page, list)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.Page = page or "Page 1"
    o.List = list or {}
    o.Debug = false
    return o
end

----------------------------------------------------------------------------------------
Module = {Layer = Layer, LayerController = LayerController}

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

for key, fun in pairs(Uci) do
    Module[key] = fun
end -- add standard Uci library to this library

return Module
