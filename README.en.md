![British Flag](docs/image/uk.svg) → ![Japanese Flag](docs/image/japan.svg) [このドキュメントを日本語で表示するには、ここをクリックしてください…](https://www.github.com/pokemium/understanding-pokemon-red)

# Pokémon Red – Detailed Disassembly Documentation

![English Translation Cover](docs/image/cover.en.png)

**Note:** _This repository is incomplete (as is this translation effort)!_

This repository is a comment-annotated fork of the [Pret collective](https://www.github.com/pret)’s [split disassembly of Pokémon Red](https://www.github.com/pret/pokered), with accompanying detailed documentation explaining some of the codebase’s core functions. The research present here was authored by [@pokemium](https://www.github.com/pokemium) and is in the process of being translated by [@andidavies92](https://www.github.com/andidavies92).

Please note that the target ROM is the _English-language_ version of Pokémon Red.

## Overview

As mentioned above, this repository contains the Pokémon Red disassembly and adds detailed explanations in Japanese, which will gradually be translated into English, as in this README. The original research effort provides the following:

* Comments added to the source code in Japanese.
* The comments are in a standardised format in order to maximise readability when used in conjunction with relevant [VS Code extensions](https://marketplace.visualstudio.com/items?itemName=donaldhays.rgbds-z80).
* Formal documentation for data formats and concepts unique to Pokémon Red.

These additions provide much-needed extra detailed information to the [original repository](https://www.github.com/pret/pokered).

## Prerequisites

This documentation assumes you already have some knowledge of:

* Low-level compilation steps, i.e. assemblers, linkers, etc.
* Game Boy hardware specifications, such as its Z80-like ISA (instruction set architecture), interrupts, MBCs (memory bank controllers), banking, and so on.
* [RGBDS (Rednex Game Boy Development System)](https://www.github.com/rednex/rgbds).

It’s also recommended to use Visual Studio Code along with this [RGBDS-tailored extension](https://marketplace.visualstudio.com/items?itemName=donaldhays.rgbds-z80) when wanting to read the code in an editor.

## Sections

Click on any of these topics to read more about them:

* [2bpp graphics format](docs/2bpp.en.md)
* [Binary-coded decimal](docs/bcd.en.md)
* [Boulders](docs/boulder.en.md)
* [Button input](docs/joypad.en.md)
* [Cartridge](docs/cartridge.en.md)
* [Conditional-visibility object](docs/missable_object.en.md)
* [Diploma](docs/diploma.en.md)
* [Events](docs/event.en.md)
* [Following NPCs](docs/follow.en.md)
* [Glossary](docs/term.en.md)
* [Gym badges](docs/badge.en.md)
* [Hidden objects](docs/hidden_object/README.en.md)
* [Intro sequence](docs/intro.en.md)
* [List data structure](docs/list.en.md)
* [List menus](docs/list_menu.en.md)
* [Macros](docs/macro.en.md)
* [Map](docs/map/README.en.md)
* [Menus](docs/menu.en.md)
* [PC](docs/pc/README.en.md)
* [pic data format](docs/pic/README.en.md)
* [Pokédex](docs/pokedex.en.md)
* [Pokémon data structure](docs/pokemon/README.en.md)
* [Pre-registering functions (“predef”)](docs/predef.en.md)
* [rgbgfx graphics converter](docs/rgbgfx.en.md)
* [ROM banks](docs/bank.en.md)
* [Saving](docs/save.en.md)
* [Simulated button presses](docs/simulated_joypad.en.md)
* [Sprites](docs/sprite/README.en.md)
* [Text](docs/text/README.en.md)
* [Tiles](docs/map/tile.en.md)
* [Title screen](docs/titlescreen.en.md)
* [Trainer data structure](docs/trainer/README.en.md)
* [Warps](docs/warp/README.en.md)
* [Wild Pokémon](docs/wild_pokemon.en.md)

## Codebase structure

| Directory/file                 | Contents                                                                                |
|--------------------------------|-----------------------------------------------------------------------------------------|
| [audio/](audio)                | _Code pertaining to music and sound effects._                                           |
| [constants/](constants)        | _Abstracted constants that are referenced throughout the codebase._                     |
| [data/](data)                  | _Tabular game data loaded into memory on demand._                                       |
| [engine/](engine)              | _The core gameplay mechanics are implemented here._                                     |
| [gfx/](gfx)                    | _Sprite graphics, blocksets, tilesets and tilemaps live here._                          |
| [home/](home)                  | _Initialisation code and utilities._                                                    |
| [macros/](macros)              | _Macro definitions that can be called-on anywhere in the codebase._                     |
| [maps/](maps)                  | _Data for all explorable areas of the game, both inside and outside._                   |
| [pic/](pic)                    | _Graphics data for Pokémon and trainers._                                               |
| [scripts/](scripts)            | _Higher-level scripts used to define events in the game._                               |
| [text/](text)                  | _All the text data for the game is stored here._                                        |
| [tools/](tools)                | _Various utility scripts (in C and Python) for things like graphics data encoding._     |
| [audio.asm](audio.asm)         | _All audio data and subroutines get included here, as well as some extra definitions._  |
| [charmap.asm](charmap.asm)     | _Unicode string to tile mappings, so that text can be defined as string literals._      |
| [constants.asm](constants.asm) | _Includes for all constant definitions._                                                |
| [home.asm](home.asm)           | _Initialisation code and utility subroutines._                                          |
| [hram.asm](hram.asm)           | _Defines what data gets placed in high RAM._                                            |
| [macros.asm](macros.asm)       | _Includes for all macro definitions._                                                   |
| [main.asm](main.asm)           | _Entry point for the game._                                                             |
| [pokered.link](pokered.link)   | _Linker script that specifies which address and in which bank each section is located._ |
| [sram.asm](sram.asm)           | _Defines what data is to be saved to the cartridge’s SRAM and where it’s located._      |
| [text.asm](text.asm)           | _Dialogue text is defined here and all other text is loaded via includes._              |
| [vram.asm](vram.asm)           | _Video RAM vectors defining the address spaces for graphics data to be loaded into._    |
| [wram.asm](wram.asm)           | _Memory layout for where pieces of data get stored in work RAM._                        |
