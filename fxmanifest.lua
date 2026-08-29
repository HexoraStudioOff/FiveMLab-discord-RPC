fx_version 'cerulean'
game 'gta5'

author 'RPSync'
description 'A discord RPC script for FiveM server in collab with FiveM Lab'
version '1.0.1'
lua54 'yes'

shared_script 'config.lua'

client_script 'client.lua'
server_script 'server.lua'

escrow_ignore {
    'config.lua',
}
