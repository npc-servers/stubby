STUBBY = STUBBY or {}
STUBBY.SWEPStubs = STUBBY.SWEPStubs or {}
STUBBY.SENTStubs = STUBBY.SENTStubs or {}

local function autoTable()
    return setmetatable( {}, {
        __index = function( tbl, k )
            local newTable = autoTable()
            rawset( tbl, k, newTable )
            return newTable
        end
    } )
end

local function setEnv( gVar, func )
    local env = {
        [gVar] = autoTable()
    }

    setmetatable( env, {
        __index = _G,
        __newindex = _G
    } )

    setfenv( func, env )

    return env[gVar]
end

local swepFiles = file.Find( "stubby/sweps/*.lua", "LUA" )
local sentFiles = file.Find( "stubby/sents/*.lua", "LUA" )

if SERVER then
    for _, fil in ipairs( swepFiles ) do
        AddCSLuaFile( "stubby/sweps/" .. fil )
    end

    for _, fil in ipairs( sentFiles ) do
        AddCSLuaFile( "stubby/sents/" .. fil )
    end
end

-- Compile the files
do
    for _, fil in ipairs( swepFiles ) do
        local stub = CompileFile( "stubby/sweps/" .. fil )
        local tbl = setEnv( "SWEP", stub )
        stub()

        local class = string.StripExtension( fil )
        STUBBY.SWEPStubs[class] = tbl
    end

    for _, fil in ipairs( sentFiles ) do
        local stub = CompileFile( "stubby/sents/" .. fil )
        local tbl = setEnv( "ENT", stub )
        stub()

        local class = string.StripExtension( fil )
        STUBBY.SENTStubs[class] = tbl
    end
end

local function applyStub( original, stubtbl )
    table.Merge( original, stubtbl )
end

hook.Add( "PreRegisterSWEP", "StubbyPreRegisterSWEP", function( originalTbl, class )
    local stubTbl = STUBBY.SWEPStubs[class]
    if not stubTbl then return end
    applyStub( originalTbl, stubTbl )
end )

hook.Add( "PreRegisterSENT", "StubbyPreRegisterSENT", function( originalTbl, class )
    local stubTbl = STUBBY.SENTStubs[class]
    if not stubTbl then return end
    applyStub( originalTbl, stubTbl )
end )

-- Autorefresh, force reload
if STUBBY.Loaded then
    for className, stubTbl in pairs( STUBBY.SWEPStubs ) do
        local original = weapons.GetStored( className )
        if original then
            applyStub( original, stubTbl )
        end
    end

    for className, stubTbl in pairs( STUBBY.SENTStubs ) do
        local original = scripted_ents.GetStored( className )
        if original then
            applyStub( original, stubTbl )
        end
    end

    -- Loop over all entities and check if they are in the stubby list
    for _, ent in ipairs( ents.GetAll() ) do
        local class = ent:GetClass()

        local swepStub = STUBBY.SWEPStubs[class]
        if swepStub then
            local original = weapons.GetStored( class )
            if original then
                applyStub( ent, swepStub )
            end
        end

        local sentStub = STUBBY.SENTStubs[class]
        if sentStub then
            local entTbl = ent:GetClass()
            applyStub( entTbl, sentStub )
        end
    end
end

STUBBY.Loaded = true
