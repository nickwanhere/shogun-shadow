# Way of Shogun - Game Design Document (Main)

## Executive Summary

**Project Title**: Way of Shogun
**Tagline**: Master information, command armies, forge your destiny in real-time
**Development Approach**: Step-based sprint with AI-driven development
**Platform**: PC/Mac (Single-player, 2D, Indie scale)
**Engine**: Godot 4.x with CLI/AI debugging enabled

## Elevator Pitch

A real-time strategy game blending Mount & Blade's directional combat with Total War-scale warfare, featuring an innovative information warfare system where truth is the ultimate weapon. Players control a Shogun General, command armies on a chess-style strategic map, and make critical decisions in real-time perch-style meetings while battles rage on in the background.

## Target Audience

- Strategy enthusiasts (Total War, Paradox games)
- Fans of medieval warfare and Japanese history
- Players who value tactical depth and decision-making
- Indie game supporters

## Unique Selling Propositions

1. **Information Warfare**: Fog of war mechanics where information is currency and truth is weapon
2. **Real-Time Decision Making**: Make critical strategic choices while battles continue in background
3. **Seamless Transitions**: Flow between combat, command, and decision interfaces
4. **Skill Carry-Over**: Progress skills across roles (future feature)
5. **Traditional Japanese Aesthetic**: Ink wash art style with modern gameplay

## Inspirations & References

- **Mount & Blade**: Directional combat system
- **Total War**: Scale and army command
- **XCOM**: Fog of war and information systems
- **Paradox Games**: Strategic depth and interface design
- **Traditional Japanese Art**: Sumi-e ink wash aesthetic

## MVP Scope - Step-Based Development

### Critical Path (Must Complete)

1. Basic directional combat (4 directions only - simplified)
2. Fog of war with 1 information type (troop positions)
3. Chess-style map with basic army movement
4. Perch-style decision interface (tactical meetings only)
5. Shogun General with 2 passive skills

### Deferred to Future Steps

- Multiple information types (beyond troop positions)
- Strategic meetings
- Formation system
- Secret agents
- Role switching
- Multi-region campaign

## Success Metrics

- Playable prototype in 1 week (9 steps)
- Core loop functional: Combat → Information → Command → Decision
- Performance: 30 FPS minimum, 50 units per battle
- AI debugging: Full state inspection via CLI

## Document Structure

This GDD is broken into modular documents for easier creation and management:

1. **GDD_Main.md** (this file) - Overview and summary
2. **GDD_Core_Systems.md** - Combat, Information, Army Command, Meeting systems
3. **GDD_Role_System.md** - Shogun General, skills, future architecture
4. **GDD_Game_World.md** - Map design, factions, settings
5. **GDD_Technical_Specs.md** - Godot setup, architecture, performance
6. **GDD_Art_Audio.md** - Art style, AI prompts, asset list
7. **GDD_Development_Roadmap.md** - 9-step development plan
8. **GDD_Risk_Assessment.md** - Risks and mitigation strategies
9. **GDD_Appendices.md** - CLI commands, prompt list, checklists

---

**Document Version**: 1.0
**Last Updated**: 2025-01-11
**Next Review**: After Step 5 completion
