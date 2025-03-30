-- # Modules Folder Structure  

-- ## Purpose  
-- The Modules folder stores reusable scripts (ModuleScripts) to keep the game organized and efficient.  

-- ## Structure  
-- - **Modules (Folder)** → Holds all ModuleScripts.  
--   - **PlayerModule (ModuleScript)** → Handles player-related functions.  
--   - **CombatModule (ModuleScript)** → Manages combat mechanics.  
--   - **UIManager (ModuleScript)** → Controls UI interactions.  
--   - **QuestSystem (ModuleScript)** → Handles quests and progression.  

-- ---

-- # Example Module: CombatModule  

-- ```lua
-- local CombatModule = {}

-- CombatModule.DamageMultiplier = 1.5
-- CombatModule.CriticalHitChance = 0.1

-- function CombatModule.CalculateDamage(baseDamage, isCritical)
--     local damage = baseDamage * CombatModule.DamageMultiplier
--     if isCritical then
--         damage = damage * 2 -- Critical hit deals double damage
--     end
--     return damage
-- end

-- return CombatModule
