# Queima 25 - Party Game App

A modern iOS party game similar to drinking games, designed for social gatherings and parties.

## Game Concept

Queima 25 is an interactive party game where:
1. Players enter their names (up to 15 participants)
2. The game randomly selects players and displays interactive phrases/challenges
3. Players tap the screen to advance to the next phrase
4. Various categories of challenges keep the game exciting

## Features

- **Modern UI**: Clean, visually appealing interface with a dark color scheme
- **Player Management**: Add or remove players before starting the game
- **Multiple Challenge Types**:
  - Normal phrases/dares
  - "I never..." statements
  - Timed challenges with built-in countdown timer
  - Game mechanics with interactive elements
  - Warning challenges that establish ongoing rules
- **Dynamic Content**: Phrases automatically incorporate random player names
- **Landscape Orientation**: Optimized for shared viewing during parties

## Categories

- **Normal**: Standard dares and penalties
- **Warning**: Establishes ongoing rules for players
- **Game**: Interactive game mechanics requiring player participation
- **Never**: Classic "I never..." statements
- **Timed Challenges**: Tasks with countdown timers

## Technical Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5+
- SpriteKit framework

## Setup Instructions

1. Clone the repository
2. Open the Queima25.xcodeproj file in Xcode
3. Add a sound file for the tap sound:
   - Place an MP3 sound file at `Queima25/Sounds/tap.mp3`
   - Sound files can be found on free sound websites
4. Build and run on your iOS device or simulator

## Project Structure

- **GameModel.swift**: Game logic, phrases database, and player management
- **MainMenuScene.swift**: Player registration screen with modern UI
- **GameplayScene.swift**: Interactive gameplay screen with phrase display
- **GameViewController.swift**: Main controller managing view and scene transitions
- **GameScene.swift**: Base scene implementation with shared functionality

## Customization

You can easily customize the game by:
1. Adding more phrases in the `phrases` array in `GameModel.swift`
2. Adjusting the UI colors in the scene files (custom color scheme variables)
3. Creating new phrase categories
4. Adding additional game mechanics 