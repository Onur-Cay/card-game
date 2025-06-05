

/// GameActionButtons
/// -------------------
/// This widget contains the action buttons available to the player during gameplay.
/// Responsibilities:
/// - Display context-specific buttons such as:
///   - "Play Card"
///   - "Draw Card"
///   - "Pickup Pile"
///   - "Ready" (during swap phase)
/// - Enable or disable buttons based on game phase and player state
///
/// To be implemented:
/// - Hook buttons into game logic callbacks
/// - Reflect valid/invalid states (e.g., disable if no valid move)
/// - Update based on active phase and current player turn