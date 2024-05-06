# Hangman Game in Assembly 8086

This repository contains an implementation of the classic Hangman game in Assembly language (8086 architecture). The Hangman game challenges players to guess a hidden word by suggesting letters within a limited number of attempts. Players must guess the word correctly before running out of attempts to win the game.

## Game Description

Hangman is a popular word-guessing game where one player thinks of a word and the other player tries to guess it by suggesting letters. In this Assembly 8086 version of Hangman, the game proceeds as follows:

1. The game randomly selects a word from a predefined list of words or phrases. The word is displayed to the player as a series of underscores, representing each letter in the word.

2. The player is prompted to guess a letter from the alphabet. If the guessed letter is part of the word, all occurrences of that letter are revealed in the word. Otherwise, the player loses one attempt, and a part of the hangman figure is drawn on the screen.

3. The game continues until the player correctly guesses all the letters in the word (winning condition) or runs out of attempts (losing condition).

4. If the player wins, a victory message is displayed, congratulating the player on successfully guessing the word. If the player loses, a defeat message is displayed, revealing the hidden word and inviting the player to try again.

## Features

### 1. Random Word Selection

The game randomly selects a word from a predefined list of words or phrases, ensuring a varied and unpredictable gameplay experience.

### 2. Letter Guessing

Players can guess letters from the alphabet to uncover the hidden word. Correct guesses reveal all occurrences of the guessed letter in the word, while incorrect guesses result in the deduction of attempts.

### 3. Win/Loss Detection

The game detects when the player has successfully guessed all the letters in the word (winning condition) or has run out of attempts (losing condition), determining the outcome of the game accordingly.

### 4. Graphics (Optional)

Optionally, the game can include ASCII art representing the hangman figure, progressively revealed as the player makes incorrect guesses. This feature enhances the visual appeal of the game and adds an element of suspense.

## Usage

To play the Hangman game implemented in Assembly 8086, follow these steps:

1. Clone the repository to your local machine.

2. Assemble and run the Assembly program using an 8086 emulator or assembler.

3. Follow the on-screen prompts to guess letters and attempt to uncover the hidden word within the specified number of attempts.

4. Enjoy the challenge of Hangman and strive to win by correctly guessing the word!

## Contributing

Contributions to this repository are welcome! If you have suggestions for improvements, new features, or bug fixes, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
