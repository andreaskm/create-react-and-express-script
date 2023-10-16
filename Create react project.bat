mkdir client
mkdir server

:: top level
call npm init -y
call npm install -D concurrently
call npm pkg set scripts.dev="concurrently npm:dev:client npm:dev:server"
call npm pkg set scripts.dev:client="cd client && npm run dev"
call npm pkg set scripts.dev:server="cd server && npm run dev"

:: client
cd client
call npm init -y
call npm install -D parcel
call npm i react react-dom react-router-dom
:: new
rename package.json oldpackage.json
findstr /V "main" oldpackage.json > package.json
del oldpackage.json
(
    echo ^<!DOCTYPE html^>
    echo ^<html lang="en"^>
    echo ^<head^>
    echo     ^<meta charset="UTF-8"^>
    echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
    echo     ^<title^>React project^</title^>
    echo ^</head^>
    echo ^<body^>
    echo     ^<div id="root"^>^</div^>
    echo ^</body^>
    echo ^<script src="index.jsx" type="module"^>^</script^>
    echo ^</html^>
) > index.html
call npm pkg set scripts.dev="parcel watch index.html"
(
    echo import React from "react";
    echo import ReactDOM from "react-dom/client"
    echo const root = ReactDOM.createRoot^(document.getElementById^("root"^)^);
    echo     root.render^(^<h1^>Hello React!^</h1^>^)
) > index.jsx

cd ..

cd server
call npm init -y
call npm install -D nodemon
call npm install express
call npm pkg set scripts.dev="nodemon server.js"
(
	echo import express from "express";
	echo const app = express^(^);
	echo app.use^(express.static^("../client/dist"^)^)
	echo app.listen^(3000^);
) > server.js

:: new
call npm pkg set type="module"
pause

