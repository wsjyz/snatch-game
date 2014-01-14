--
-- Author: ivan.vigoss@gmail.com
-- Date: 2013-12-27 17:30:34
--
SLS_SERVER_HOST = "http://www.izhuangyuan.cn:8080/sls"
-- SLS_SERVER_HOST = "http://192.168.0.96:8089/sls"

--URLS
--player
RANDOM_NAME_URL = "/player/randomName"
PLAYER_INFO_URL = "/player/%s" --playerId
RIGESTER_URL = "/player/register"
UPDATE_EXT_URL = "/update-exp/%s/%d"
--topic
TOPIC_LIST_URL="/topic/random/%d" --level
--hall
HALL_INFO_URL = "/hall/get"
--award
AWARD_LIST_URL = "/award/list/%d" --level
LOTTERY_URL = "/award/win/%s/%s" --awardId,playerId
PRIZE_LIST_URL = "/award/get-player-prize-list/%s/3"
RANKING_LIST_URL = "/award/get-ranking-list/3"

function getUrl(pattern, ...)
	return string.format(SLS_SERVER_HOST .. pattern, ...)
end