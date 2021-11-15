fx_version 'cerulean'
game 'gta5'

description 'QB-telco'
version '1.0.0'

shared_scripts { 
	'config.lua'
}

client_script 'client/main.lua'
server_script 'server/main.lua'


files {
	'HTML/FuseBox.html',
	'HTML/FuseBox.js',
	'HTML/FuseBox.css'
}

ui_page 'HTML/FuseBox.html'