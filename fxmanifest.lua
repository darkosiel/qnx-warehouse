fx_version 'cerulean'
game 'gta5'

client_scripts {'config.lua', 'client/*.lua'}

server_scripts {'@mysql-async/lib/MySQL.lua', 'config.lua', 'server/*.lua'}

ui_page 'html/index.html'
files {'html/index.html', 'html/css/*.css', 'html/js/*.js', 'html/images/*.png'}

lua54 'yes'
escrow_ignore {'config.lua'}
