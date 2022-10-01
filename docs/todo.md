- We know: 1 room -> 4 rooms

  - No pathing (randomized room, not generating maps)
  - 4 types of rooms
    - Levels 1,2,3, and boss room
  - Switch between rooms when fight is over
    - Zooms out from current room, shows rooms in cardinal directions
      - Select & confirm. 10 second timer

- Zoom out mechanic

- Views:

  - Main view (just the room you're battling in)
  - Stat up view (e.g. finished room, could be slightly more zoomed out? Maybe an art thing? Modal?)
  - Room selection view (which is center room & adjacent four rooms)

- Rooms
- Iframes
- A player
  - Movement mechanics
  - Weapon mechanics
    - Charge up animations
- Enemies
  - Movement AI
  - Targeting / attacking AI
    - Telegraphing behavior (indicating attack)
- UI (menu)
- UI (healthbars, abilities)
- Items (health pickups, mana pickups? coins? for score? etc)
- Keys (stretch goal)
- Inventory? (thank god not)

- Main
  - Main menu state
  - Lose screen state
  - PlayState
    - Combat substate (normal view while fighting)
    - End combat substate (normal view while picking stat ups)
    - Room select substate (normal view while choosing room)
  - FlxSprite (physical entity, environmental hazards, player, enemy, coins, keys, whatever)
    - Weapon
      - private swing() {
        }
    - Player
    - Parent enemy
      - Individual enemy implementations that inherit from parent enemy
    - Pickup class
      - Keys
      - Health
      - Whatever
    - Environment object (hazard, blocks, bricks, whatever)
  - Class with some background?
- lib

  - movementMath
    - cosineAsshole whatever

- Properties of room:

  - Enemies within room
  - Level of room
  - Background of room
  - Powerup linked to room

- A start screen / state -> play state
- Initialize player
- Initialize Combat substate / first room
- Do a timer, have that succeed after 10 seconds -> switch to stat up state
- Have a timer have that finish after 10 seconds -> switch to room select state
- -> combat state
