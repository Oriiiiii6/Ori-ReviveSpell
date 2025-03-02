fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'ori (us3rrrr.)'
description 'Revive command with Discord role'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib'
}
