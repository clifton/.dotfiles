#!/bin/bash

# download the font
APP_FONT_URL="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf"
(stat $HOME/Library/Fonts/sketchybar-app-font.ttf || curl -L $APP_FONT_URL -o $HOME/Library/Fonts/sketchybar-app-font.ttf) &>/dev/null

# General Icons
LOADING=􀖇
APPLE=􀣺
PREFERENCES=􀺽
ACTIVITY=􀒓
LOCK=􀒳
BELL=􀋚
BELL_DOT=􀝗

# Git Icons
GIT_ISSUE=􀍷
GIT_DISCUSSION=􀒤
GIT_PULL_REQUEST=􀙡
GIT_COMMIT=􀡚
GIT_INDICATOR=􀂓

# Spotify Icons
SPOTIFY_BACK=􀊎
SPOTIFY_PLAY_PAUSE=􀊈
SPOTIFY_NEXT=􀊐
SPOTIFY_SHUFFLE=􀊝
SPOTIFY_REPEAT=􀊞

# Yabai Icons
YABAI_STACK=􀏭
YABAI_FULLSCREEN_ZOOM=􀏜
YABAI_PARENT_ZOOM=􀥃
YABAI_FLOAT=􀢌
YABAI_GRID=􀧍

# Battery Icons
BATTERY_100=􀛨
BATTERY_75=􀺸
BATTERY_50=􀺶
BATTERY_25=􀛩
BATTERY_0=􀛪
BATTERY_CHARGING=􀢋

# Volume Icons
VOLUME_100=􀊩
VOLUME_66=􀊧
VOLUME_33=􀊥
VOLUME_10=􀊡
VOLUME_0=􀊣

# WiFi
WIFI_CONNECTED=􀙇
WIFI_DISCONNECTED=􀙈
