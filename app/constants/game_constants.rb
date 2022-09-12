module GameConstants
  MAX_PLAYERS = 4
  MAP_SIZE = 21
  BOX_COUNT = 20
  EMPTY_PLACE = 0
  BOX_PLACE = 1
  HARD_WALL = 2
  STARTING_INFO = [
    { x: 0, y: 0, sprite: "m1", direction: 'DOWN' },
    { x: MAP_SIZE - 1, y: 0, sprite: "m2", direction: 'DOWN' },
    { x: MAP_SIZE - 1, y: MAP_SIZE - 1, sprite: "f1", direction: 'UP' },
    { x: 0, y: MAP_SIZE - 1, sprite: "f2", direction: 'UP' },
  ].freeze
end