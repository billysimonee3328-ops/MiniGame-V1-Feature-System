# SA-MP / open.mp TextDraw Memory Grid Mini-Game

<img width="1366" height="768" alt="Screenshot (593)" src="https://github.com/user-attachments/assets/579643f8-5f78-441b-a46c-b0cadbc8832e" />


<img width="1366" height="768" alt="Screenshot (594)" src="https://github.com/user-attachments/assets/1dcd09a0-8d56-4170-9e38-91b84cbc8e08" />

A dynamic, interactive **TextDraw-based mini-game** designed for SA-MP and open.mp servers. This mini-game challenges players' memory and reaction speed by hiding target numbers within a constantly shifting grid of numbers.

---

## Author & Credits

* **Developer:** Billy Simonee (ANX)
* **Language:** Pawn
* **Platform:** SA-MP / open.mp

---

## Mechanics & Game System

1. **Target Initialization:**
   * Upon initialization via `ShowPlayerMiniGame`, the system generates **6 unique random numbers** assigned as primary targets.
   * Out of these 6 numbers, 3 are randomly selected using the **Fisher-Yates Shuffle** algorithm to become **Hidden Targets**.

2. **Transition & Delay Mechanism:**
   * During the initial 3 seconds, all target numbers are displayed to allow players time to memorize them.
   * After 3 seconds (`DelayHiddenNumberMiniGame`), the 3 selected target numbers are masked with `"??"` and their background boxes turn red (`0xFF0000FF`).
   * Interactive grid buttons are enabled only after the numbers are hidden.

3. **Dynamic Grid Shuffling:**
   * The selection grid (IDs 73–132) constantly **re-shuffles its values every 2 seconds** via the `MiniGameRandomSelect` timer.
   * The system automatically injects the 3 hidden target numbers into random slots within the grid during each shuffle, ensuring that **a correct option is always present**.

4. **Click Detection & Penalties:**
   * **Correct Selection:** Clicking a hidden target reveals its true value and changes the target indicator box color to **Green** (`0x00FF00FF`).
   * **Incorrect Selection:** Clicking a wrong number triggers an error sound (Sound ID `5206`), briefly flashes the loading bar red, and applies a **time penalty** (advancing the loading bar by `5%`).

5. **Time Management & Cleanup:**
   * A progress bar tracks the remaining time.
   * If time expires or the player disconnects, active timers (`LoadingProgressBar`, `MiniGameNumberSelectRandTimer`) are terminated immediately, and array variables are reset to prevent memory leaks.

* 🧩 **Dynamic Grid & TextDraw System:** Fully responsive and clean UI constructed using custom TextDraws.
* 🔀 **Randomized Target Shuffling:** Automatically generates unique target numbers and randomized positions for each game session.
* ⏱️ **Time Penalty & Bonus Mechanics:**
  * **Correct Guess (`-= 10`):** Rewards players by restoring/extending the loading progress bar.
  * **Wrong Guess (`+= 5`):** Applies a penalty, draining the progress bar faster.
* 🔊 **Audio & Visual Feedback:** Dynamic color state changes (green for correct, red for wrong) with native game sound effects.
* 🛠️ **Optimized Pawn Code:** Memory-safe execution with proper stack handling and minimal timer overhead.
  
---

## Dependencies

* [a_samp](https://github.com/pawn-lang/YSI-Includes) (Standard SA-MP Library)
* [Pawn.CMD](https://github.com/katembor/Pawn.CMD) (Command Processor)
* [textdraw-streamer](https://github.com/SreeT/textdraw-streamer) (Player TextDraw Management)
* [All Plguin](https://www.mediafire.com/file/9lw4g7f2418zmhg/plugins.rar/file) (Download)
---

## TextDraw Index Mapping

| Index Range | Function / Component |
| :--- | :--- |
| **`1` - `60`** | Interactive Transparent Button Layer (*Selectable*) |
| **`61` - `66`** | Target Indicator Boxes (`Target Index - 6`) |
| **`67` - `72`** | Primary Target Number TextDraws |
| **`73` - `132`** | Selection Grid Number Displays (`Button Index + 72`) |
| **`134`** | Loading Progress Bar |

---

## Usage

1. Ensure all required includes are present in your server's include folder.
2. Include the source code within your gamemode or filterscript.
3. Call the function to display the mini-game to a player:

```pawn
// Displays the mini-game with a default 60-second limit
ShowPlayerMiniGame(playerid, 60);

// Or execute via the built-in command
CMD:minigame(playerid, params[])
{
    ShowPlayerMiniGame(playerid);
    return 1;
}
