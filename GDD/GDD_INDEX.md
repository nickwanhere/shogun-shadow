# Way of Shogun - Complete Game Design Document

## Document Index

This index provides navigation to all GDD documents for "Way of Shogun" project.

---

## Document Structure

### 1. GDD_Main.md
**Overview and Summary**
- Executive Summary
- Elevator Pitch
- Target Audience & Platform
- Unique Selling Propositions
- Inspirations & References
- MVP Scope Definition
- Success Metrics
- Document Structure Overview

**Purpose**: High-level overview of entire project

---

### 2. GDD_Core_Systems.md
**Core Gameplay Systems**
- Simplified Combat System (4-directional attacks, blocking, damage)
- Information Warfare System (fog of war, information retrieval, timing)
- Army Command System (chess-style map, movement, attack orders)
- Meeting System (perch-style UI, tactical decisions, real-time integration)

**Purpose**: Detailed specifications for all core gameplay mechanics

---

### 3. GDD_Role_System.md
**Role and Skill System**
- Shogun General role (MVP focus)
- 2 Passive Skills (Tactical Insight, Charisma)
- Skill Progression System
- Future Role Switching Architecture
- 5 Additional Skills (reserved for later)

**Purpose**: Role mechanics, skill system, and future role switching framework

---

### 4. GDD_Game_World.md
**World and Setting**
- Single Region Map Design (50×50 tiles, terrain types)
- Factions & Territories (2 factions, ownership mechanics)
- Settlements (castles, villages)
- Creative Shogun Era Setting
- Environmental Factors (weather, day/night)
- Resource System (gold, food)

**Purpose**: Game world, map design, factions, and setting details

---

### 5. GDD_Technical_Specs.md
**Technical Specifications**
- Godot 4.x Engine Selection
- CLI/AI Debugging Capabilities
- AI-Friendly Architecture
- Performance Targets (30 FPS+, <300MB)
- System Architecture (core systems hierarchy)
- MVP Technical Requirements
- Debugging & Testing

**Purpose**: Technical implementation details, debugging integration, and architecture

---

### 6. GDD_Art_Audio.md
**Art and Audio Specifications**
- Art Style Guide (Sumi-e, Ukiyo-e)
- AI Art Generation Prompts (detailed for all assets)
- Recommended AI Tools (Midjourney, DALL-E, Stable Diffusion)
- MVP Asset List (6 tiles, 40 sprites, 4 icons, 10 UI, 3 backgrounds)
- Audio Style & References
- UI/UX Design Principles

**Purpose**: Complete art generation guide with detailed AI prompts

---

### 7. GDD_Development_Roadmap.md
**Step-Based Development Plan**
- Step 1: Godot Setup & Base Architecture
- Step 2: Combat System Implementation
- Step 3: Information System Implementation
- Step 4: Army Command System
- Step 5: Meeting System Implementation
- Step 6: Skill System Implementation
- Step 7: AI Art Generation & Integration
- Step 8: Integration & Testing
- Step 9: Final Documentation & Delivery

Each step includes:
- Prerequisites
- Actions (detailed)
- Verification criteria
- Parallel execution notes
- Dependencies
- Time estimate

**Purpose**: Sequential development plan optimized for AI-driven development

---

### 8. GDD_Risk_Assessment.md
**Risk Management**
- Development Risks (performance, complexity, integration, timeline)
- Design Risks (information system balance, skill balance, depth)
- Technical Risks (engine compatibility, AI integration)
- Mitigation Strategies for all risks
- Contingency Plans
- Risk Management Process (daily/weekly reviews)

**Purpose**: Comprehensive risk identification and mitigation strategies

---

### 9. GDD_Appendices.md
**Reference Materials**
- Appendix A: AI Debugging Command Reference
- Appendix B: AI Art Generation Prompt List (consolidated)
- Appendix C: Step Verification Checklists
- Appendix D: Success Metrics Checklist
- Appendix E: Glossary (game-specific and technical terms)

**Purpose**: Quick reference materials and checklists

---

## Quick Reference

### Core Game Loop
```
Combat (Directional Attacks) → Information (Fog of War + Retrieval) → Command (Chess-Style Map) → Decision (Tactical Meetings)
```

### Key Features (MVP)
1. Simplified 4-directional combat
2. Fog of war with 1 information type (troop positions)
3. Chess-style strategic map with army command
4. Perch-style tactical meeting interface (real-time decisions)
5. Shogun General with 2 passive skills

### Development Timeline
- **Total Steps**: 9
- **Estimated Time**: 1 week (36-52 hours with parallelization)
- **Approach**: Sequential steps with parallel work where possible

### Technology Stack
- **Engine**: Godot 4.x
- **Language**: GDScript (Python-like)
- **Platform**: PC/Mac
- **AI Debugging**: CLI commands, state export, automated testing

### Art Style
- **Primary**: Sumi-e (ink wash)
- **Secondary**: Ukiyo-e (woodblock print)
- **Tools**: Midjourney, DALL-E, Stable Diffusion
- **Total Assets**: 63 items (6 tiles, 40 sprites, 4 icons, 10 UI, 3 backgrounds)

---

## How to Use This GDD

### For Developers
1. Start with **GDD_Main.md** for overview
2. Read **GDD_Technical_Specs.md** for architecture
3. Follow **GDD_Development_Roadmap.md** step-by-step
4. Reference **GDD_Core_Systems.md**, **GDD_Role_System.md**, **GDD_Game_World.md** for detailed specs
5. Use **GDD_Art_Audio.md** for AI art generation
6. Consult **GDD_Appendices.md** for commands and checklists
7. Review **GDD_Risk_Assessment.md** throughout development

### For AI Agents
1. Read **GDD_Main.md** for context
2. Use **GDD_Appendices.md - Appendix A** for CLI debugging commands
3. Follow **GDD_Development_Roadmap.md** step-by-step
4. Use **GDD_Appendices.md - Appendix C** for verification criteria
5. Use **GDD_Appendices.md - Appendix D** for success metrics
6. Refer to **GDD_Art_Audio.md - Appendix B** for art generation prompts

### For Art/AI Generation
1. Use **GDD_Art_Audio.md** for detailed prompts
2. Use **GDD_Appendices.md - Appendix B** for consolidated prompt list
3. Follow recommended tool settings (Midjourney, DALL-E, Stable Diffusion)
4. Post-process assets using style guidelines

---

## Document Status

**Version**: 1.0
**Creation Date**: 2025-01-11
**Total Documents**: 9
**Total Pages**: ~50-60 pages (estimated)
**Status**: Complete

---

## Next Steps

1. Review all documents for clarity and completeness
2. Begin Step 1: Godot Setup & Base Architecture
3. Parallel: Start AI art prompt research
4. Track progress against timeline
5. Conduct daily risk reviews

---

**Ready for AI-driven development!**

For questions or clarifications, refer to specific document sections or contact the development team.
