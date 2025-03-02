fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'dk.kratos'
description 'QB Interfaces Compatibility for OverExtended\'s Resources' 
version '1.0.0'

client_script 'client/*.lua'
server_script 'versioncheck.lua'
shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

provide 'qb-menu'
provide 'qb-input'
provide 'qb-target'
