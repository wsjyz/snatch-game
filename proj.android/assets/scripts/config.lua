
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0
DEBUG_FPS = false
DEBUG_MEM = false

-- design resolution
-- CONFIG_SCREEN_WIDTH  = 2048
-- CONFIG_SCREEN_HEIGHT = 1536

CONFIG_SCREEN_WIDTH  = 960
CONFIG_SCREEN_HEIGHT = 640

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

GAME_TEXTURE_DATA_FILENAME  = "StandStill_default.plist"
GAME_TEXTURE_IMAGE_FILENAME = "StandStill_default.png"

GAME_MUSIC = {
	hall = "music/hall.mp3",
	game = "music/game.mp3"
}

GAME_SOUND = {
	tapButton = "sound/normal_click.mp3",
	tapBack = "sound/back_click.mp3",
	countdown = "sound/countdown.mp3",
	cheer = "sound/cheer.mp3",
	answerRight = "sound/answer_right.mp3",
	answerWrong = "sound/answer_wrong.mp3",
	failed = "sound/failed.mp3",
	popup = "sound/info_pop.mp3",
	mark = "sound/mark.mp3",
	win = "sound/win_a_prize.mp3",
	total = "sound/total.mp3"
}
