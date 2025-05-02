# Queima 25 - Party Game App

A party game app similar to "Truth or Dare" or drinking games, facilitated through a mobile iOS app.

## Game Concept

The app facilitates a party game where:
1. Players enter their names (up to 15)
2. The game displays interactive phrases/instructions for players to follow
3. Players tap anywhere to advance to the next phrase

## Features

- **Main Menu**: Add player names, view the player list, and start the game
- **Gameplay**: Display phrases with random player names, tap-to-continue mechanic
- **Player Management**: Add or remove players before starting the game
- **Dynamic Phrases**: Phrases can include player names randomly selected from the player list

## Technical Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5+

## Setup Instructions

1. Clone the repository
2. Open the Queima25.xcodeproj file in Xcode
3. Add an actual sound file for the tap sound:
   - Replace the placeholder file at `Queima25/Sounds/tap.mp3` with an actual MP3 sound file
   - Sound files can be found on free sound websites like freesound.org
4. Build and run on your iOS device or simulator

## Project Structure

- **GameModel.swift**: Contains the game logic and data management
- **MainMenuScene.swift**: The main menu screen for adding players and starting the game
- **GameplayScene.swift**: The gameplay screen that displays phrases and handles tapping
- **GameViewController.swift**: Main controller that sets up the view and initial scene

## Customization

You can easily customize the game by:
1. Adding more phrases in the `phrases` array in `GameModel.swift`
2. Changing the UI colors and fonts in the scene files
3. Adding additional game mechanics or rules 