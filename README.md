# 🛠️ SENT/SWEP Stubber

A Garry's Mod addon that allows you to modify existing SWEP (weapons) and SENT (entities) without editing their original files.

## 📝 Description

SENT/SWEP Stubber provides a clean way to override properties of existing entities and weapons in Garry's Mod. Instead of directly modifying addon files (which get overwritten during updates), you can create "stub" files that apply your customizations.

## ✨ Features

- Modify weapons and entities without editing their original files
- Changes persist through addon updates
- Hot-reload support for testing changes without restarting the game

## 📖 How to Use

### 🔫 Modifying Weapons (SWEPs)

1. Create a new Lua file in the `lua/stubby/sweps/` directory
2. Name the file exactly the same as the weapon's class name (e.g., `m9k_psg1.lua` for the M9K PSG-1)
3. In this file, define the properties you want to override:

```lua
SWEP.Primary.RPM = 350
SWEP.Primary.SpreadHip = 0.1
```

### 🧩 Modifying Entities (SENTs)

1. Create a new Lua file in the `lua/stubby/sents/` directory
2. Name the file exactly the same as the entity's class name (e.g., `spawned_weapon.lua`)
3. In this file, define the properties you want to override:

```lua
ENT.Weight = 50
ENT.MaxHealth = 200
```

### 🔍 Finding Class Names

To find a weapon or entity's class name:
- For weapons: Run the command `lua_run_cl print(LocalPlayer():GetActiveWeapon():GetClass())` in console while holding the weapon
- For entities: Aim at an entity and run `lua_run_cl print(LocalPlayer():GetEyeTrace().Entity:GetClass())` in console

### 📋 Examples

See the included `lua/stubby/sweps/m9k_psg1.lua` file for an example of modifying a weapon.

## ℹ️ Notes

- Changes will apply when the server starts or when the addon auto-refreshes (saving sh_stubby.lua)
- Some properties cannot be overridden after they've been used by the game
- Entity methods can also be overridden, not just properties
