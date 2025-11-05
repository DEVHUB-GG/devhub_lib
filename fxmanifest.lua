fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'DEVHUB (store.devhub.gg)'
description 'LIBRARY FOR DEVHUB SCRIPTS'
version '2.2.0'

client_scripts {
    -- '@vrp/lib/utils.lua',
    'config.lua',
    'core/shared/autoDetect.lua',
    'core/client/main.lua',
    'core/client/c.*.lua',
    'core/tests/c.*.lua',
    'core/tests/functions/c.*.lua',
    'modules/**/c.*.lua',
}

server_scripts {
    -- '@vrp/lib/utils.lua',
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'core/shared/autoDetect.lua',
    'core/server/main.lua',
    'core/server/s.*.lua',
    'core/tests/s.*.lua',
    'core/tests/functions/s.*.lua',
    'modules/**/s.*.lua',
}

shared_scripts {
    'core/shared/sh.*.lua',
}

ui_page "html/index.html"

files {
    'html/**/*',
}

provide 'dh_lib'

escrow_ignore {
    'core/**/*.lua',
    'modules/**/*.lua',
    'config.lua',
}