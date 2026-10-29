@echo off
set PORT=5055
set HOST=0.0.0.0
set NODE_ENV=production
cd /d "E:\AI Made Apps\Seerr\app"
"E:\AI Made Apps\Seerr\runtime\node-v22.23.4-win-x64\node.exe" dist\index.js >> "E:\AI Made Apps\Seerr\logs\seerr-service.log" 2>&1
