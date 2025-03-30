-- # Events Folder Structure  

-- ## GENERAL (Main Remote Event)  
-- This is the general-purpose RemoteEvent used for broad communication across the game.  

-- ## Subfolders as Namespaces  
-- Each subfolder represents a namespace for organizing specific RemoteEvents.  

-- ### Example Structure:  

-- - **Events (Folder)**  
--   - **GENERAL (RemoteEvent)** → Used for global event handling.  
--   - **Combat (Folder)** → Namespace for combat-related events.  
--     - Attack (RemoteEvent) → Triggered when a player attacks.  
--     - Block (RemoteEvent) → Triggered when a player blocks.  
--   - **UI (Folder)** → Namespace for UI-related events.  
--     - OpenInventory (RemoteEvent) → Opens the player's inventory.  
--     - CloseInventory (RemoteEvent) → Closes the player's inventory.  
--   - **Quests (Folder)** → Namespace for quest-related events.  
--     - StartQuest (RemoteEvent) → Triggers when a player starts a quest.  
--     - CompleteQuest (RemoteEvent) → Fires when a quest is completed.  

-- ## Benefits of This Structure:  
-- ✅ Keeps events organized and modular.  
-- ✅ Prevents name conflicts by using subfolders as namespaces.  
-- ✅ Makes it easier to manage and find specific events.  
