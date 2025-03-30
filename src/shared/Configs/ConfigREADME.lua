-- # Config File Structure  

-- ## Purpose  
-- The config file stores key game settings in a structured way, making it easy to tweak game behavior without modifying scripts.  

-- ## Structure  
-- - **GameSettings** → Stores general game settings.  
-- - **PlayerSettings** → Defines player-specific configurations.  
-- - **CombatSettings** → Adjusts combat-related values.  
-- - **UISettings** → Configures UI elements.  

-- ---

-- # Example Config File  

-- ## GameSettings  
-- MaxPlayers = 20  # Maximum number of players in the game  
-- GameMode = "Survival"  # Defines the game mode  

-- ## PlayerSettings  
-- DefaultHealth = 100  # Player's starting health  
-- WalkSpeed = 16  # Player movement speed  

-- ## CombatSettings  
-- DamageMultiplier = 1.5  # Multiplier for weapon damage  
-- CriticalHitChance = 0.1  # 10% chance for a critical hit  

-- ## UISettings  
-- EnableMinimap = true  # Toggles minimap visibility  
-- ShowHealthBars = true  # Displays health bars above players  

-- ---

-- ## Benefits of Using a Config File  
-- ✅ Centralized settings for easy changes.  
-- ✅ Reduces hardcoded values in scripts.  
-- ✅ Improves game scalability and maintenance.  
