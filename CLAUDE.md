# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a game development repository containing both PICO-8 and Pygame games. The repository includes a PICO-8 fantasy console environment for macOS and Python/Pygame projects with a virtual environment setup.

## Development Commands

### Running PICO-8 Games
```bash
# Run a PICO-8 game by name (looks in src/p8/ directory)
./run.sh game_name

# Run a PICO-8 game by full path
./run.sh /path/to/game.p8

# List available PICO-8 games
./run.sh
```

### Running Pygame Games
```bash
# Activate virtual environment and run Pygame games
cd src/pyg
../../.venv/bin/python hive_city_rampage.py

# Generate terrain sprites
cd src/pyg/assets
../../../.venv/bin/python generate_terrain.py
../../../.venv/bin/python generate_advanced_terrain.py
```

### Virtual Environment
- Python virtual environment located at `.venv/`
- Contains pygame 2.6.1 and other dependencies
- Use `../../.venv/bin/python` when running from `src/pyg/`

## Code Architecture

### Repository Structure
```
games/
├── src/
│   ├── p8/           # PICO-8 games (.p8 cartridge files)
│   └── pyg/          # Pygame projects
│       ├── assets/   # Sprite sheets, terrain tiles, generation scripts
│       └── *.py      # Game implementation files
├── pico-8/           # PICO-8 application bundle
└── .venv/            # Python virtual environment
```

### Pygame Game Architecture (hive_city_rampage.py)

#### Core Systems
- **Tile-based world**: 32x32 pixel tiles, procedural arena generation
- **Entity system**: Base Entity class with collision detection, inherited by Player and Enemy
- **Animation system**: `Anim` class for sprite animation, `AnimatedTile` for terrain animations
- **Camera system**: Smooth follow with screen shake effects
- **Director system**: Wave-based enemy spawning with intensity scaling

#### Sprite Management
- **SpriteBank**: Centralized asset loading and animation creation
- **Sprite sizing**: Configurable via `SPR` constant (48px for characters)
- **Animation strips**: Horizontal sprite sheets sliced into frames
- **Fallback rendering**: Colored placeholders when sprites are missing

#### Terrain System
- **Variant tiles**: 8 variations per tile type for visual diversity
- **Hazard tiles**: Toxic, electric, heat zones with unique visuals
- **Animated tiles**: Flickering lights, steam vents, electrical panels
- **Decal overlays**: Blood, debris, shell casings, scorch marks
- **Metadata**: JSON configuration for tile types and animations

#### Game Constants
- Display: 960x540 window, 60 FPS
- World: 120x90 tiles (3840x2880 pixels)
- Movement: Acceleration-based with friction and turn drag
- Combat: Aim assist with target prioritization

### PICO-8 Game Architecture

#### Cartridge Structure
- `.p8` files contain: `__lua__`, `__gfx__`, `__map__`, `__sfx__`, `__music__`
- Core loop: `_init()`, `_update()` or `_update60()`, `_draw()`
- State machine pattern: menu → play → gameover

#### PICO-8 Constraints
- Resolution: 128x128 pixels
- Sprites: 8x8 pixels (128x128 sprite sheet)
- Map: 128x32 tiles
- Token limit: 8192
- Cartridge size: 32KB

## Asset Generation

### Terrain Generation Scripts
- `generate_terrain.py`: Creates basic wall/floor tiles with grim dark aesthetic
- `generate_advanced_terrain.py`: Generates corner tiles, hazards, animations, decals

### Sprite Organization
```
assets/
├── marine_*.png          # Player animations (48x48 frames)
├── *_idle.png            # Enemy animations
├── terrain_*.png         # Static tile variants
├── anim_*.png           # Animated tile sheets
├── decal_*.png          # Overlay graphics
├── hazard_*.png         # Special floor tiles
└── terrain_metadata.json # Tile configuration
```

## Key Implementation Details

### Collision Detection
- Pixel-based solid checking against tile map
- Separate X/Y movement for sliding along walls
- Entity radius-based collision with corners

### Enemy AI
- Direct pursuit with speed variations by type
- Separation forces to prevent clustering
- Shooter enemies retreat at close range
- Contact damage with cooldowns and invincibility frames

### Wave System (Director)
- States: build → push → breather → spike
- Intensity scaling over time
- Budget-based spawning with pressure limits
- Safe spawn distance enforcement