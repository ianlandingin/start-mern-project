#!/bin/bash
clear
echo "Starting MERN Project"
sleep 1

next_line (){
  echo ""
}


READ_ME_OPEN=1
while [ $READ_ME_OPEN -le 1 ]
do
  read -rp "Make sure you are reading README.md before you continue (y or n): " -n 1 ANSWER
  next_line
  if [[ ! "${ANSWER,,}" == "y" && ! "${ANSWER,,}" == "n"  ]]
  then
    echo 'Please enter y or n (ctrl+c to exit)'
    next_line
  elif [ ! "${ANSWER,,}" == "y" ]; then
    echo "open README.md before running this script"
    next_line
  else
    ((READ_ME_OPEN++))
fi
done



clear
MONGO_CREATED=1
while [ $MONGO_CREATED -le 1 ]
do
  echo "Have you created a mongoDB database
  and taken note of the ff? (y or n):
  - Database name
  - Username
  - Password
  - Cluster URI"
  read -rn 1 MONGO_ANSWER
  next_line
  if [[ ! "${MONGO_ANSWER,,}" == "y" && ! "${MONGO_ANSWER,,}" == "n"  ]]; then
  echo 'Please enter y or n (ctrl+c to exit)'
  next_line
  elif [ ! "${MONGO_ANSWER,,}" == "y" ]; then
  echo "Pls create a mongodb database first and take note of the following then comeback:
  database_name:
  username:
  password:
  cluster: (don't know what cluster is? check README.md)
  
  You can follow this link if you don't know how:
  https://www.mongodb.com/basics/create-database
  
  (ctrl+c to exit)"
  next_line
  else
    ((MONGO_CREATED++))
fi
done
clear



PROJECT=1
while [ $PROJECT -le 1 ]
do
  read -rp "What should we name the project? (ex. no-spaces, No-Spaces): " PROJECT_NAME
  # Remove any whitespace
  PROJECT_NAME="${PROJECT_NAME// }"

  if [ ! "${PROJECT_NAME,,}" ]; then
  echo "Please put a project name"
  else
    echo "Project name: $PROJECT_NAME"
    ((PROJECT++))
  fi
done

DATABASE=1
while [ $DATABASE -le 1 ]
do
  read -rp "Database name?: " DATABASE_NAME
  # Remove any whitespace
  DATABASE_NAME="${DATABASE_NAME// }"

  if [ ! "${DATABASE_NAME,,}" ]; then
  echo "Please put your database name"
  else
    echo "Database name: $DATABASE_NAME"
    ((DATABASE++))
  fi
done


USER=1
while [ $USER -le 1 ]
do
  read -rp "Username?: " USER_NAME
  # Remove any whitespace
  USER_NAME="${USER_NAME// }"

  if [ ! "${USER_NAME,,}" ]; then
  echo "Please put your username"
  else
    echo "Username name: $USER_NAME"
    ((USER++))
  fi
done


PASS=1
while [ $PASS -le 1 ]
do
  read -rsp "Password?: " PASSWORD
  # Remove any whitespace
  PASSWORD="${PASSWORD// }"

  if [ ! "${PASSWORD,,}" ]; then
  echo "Please put your password"
  else
    next_line
    ((PASS++))
  fi
done


CLUSTER=1
while [ $CLUSTER -le 1 ]
do
  read -rp "Cluster name?: " CLUSTER_NAME
  # Remove any whitespace
  CLUSTER_NAME="${CLUSTER_NAME// }"

  if [ ! "${CLUSTER_NAME,,}" ]; then
  echo "Please put your cluster's name"
  else
    echo "Cluster name: $CLUSTER_NAME"
    ((CLUSTER++))
  fi
done

PORT=1
while [ $PORT -le 1 ]
do
  echo -n "What port number should the database run in dev? (ex. 5555)
press enter for default (5555): "
  read -rn 4 PORT_NUMBER
  # Remove any whitespace
  PORT_NUMBER="${PORT_NUMBER// }"
  len=${#PORT_NUMBER}

  if [ ! "${PORT_NUMBER,,}" ]
  then
    PORT_NUMBER=5555
    echo "Port: $PORT_NUMBER"
    ((PORT++))
  elif [[ "$len" -le "3" ]]
  then
    echo "Too short. Port number should be 4 digits."
    sleep 1
  else
    next_line
    echo "Port: $PORT_NUMBER"
    ((PORT++))
  fi
done
clear

echo "Initializing $PROJECT_NAME project..."
sleep 1
clear

# Create directory for new project
mkdir "$PROJECT_NAME" || echo "Error creating new project directory"
cd "$PROJECT_NAME" || echo "Error cd to new project directory"
# Create gitignore file for version control
cat <<EOF > .gitignore
### ENV Files ###
.env
EOF
# Create README file
touch README.md || echo "Error creating README.md file"
# Create directory for backend
mkdir backend || echo "Error creating backend directory"
# Initialize git version control
git init || echp "error initializing git"
# Initialize nodejs inside backend directory

######### START OF CHANGES IN THE BACKEND DIRECTORY #########
cd backend || echo "Error cd to backend directory"
npm init -y || echo "Error initializing nodejs"
# create backend structure and installing necessary packages
mkdir models || echo "Error creating models directory"
mkdir routes || echo "Error creating routes directory"
npm i express nodemon || echo "Error installing express and nodemon"
npm i mongoose || echo "Error installing mongoose"
npm i dotenv || echo "Error installing dotenv"
# Updating package.json file
cat <<-'EOF' > package.json
{
  "name": "backend",
  "version": "1.0.0",
  "description": "",
  "type": "module",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "keywords": [],
  "author": "IanLandingin",
  "license": "ISC",
  "dependencies": {
    "dotenv": "^16.3.1",
    "express": "^4.18.2",
    "mongoose": "^8.0.0",
    "nodemon": "^3.0.1"
  }
}

EOF
  # Creating index.js file and writing initial code
cat <<-'EOF' > index.js
import express from "express";
import { PORT, mongoDBURL } from "./config.js";
import mongoose from "mongoose";
import cors from "cors";

const app = express();

// Middleware for parsing body
app.use(express.json());

// Middleware for handling CORS Policy

app.get("/", (request, response) => {
  console.log(request);
  return response
    .status(234)
    .send("Welcome to your first API endpoint in nodejs");
});

// Add Middlewares for api routes


mongoose
  .connect(mongoDBURL)
  .then(() => {
    console.log("App is connected to database");
    app.listen(PORT, () => {
      console.log(`App is listening to port: ${PORT}`);
    });
  })
  .catch((error) => {
    console.log(error.message);
  });

EOF
# Creating config.js file and writing initial code
cat <<-'EOF' > config.js
import dotenv from "dotenv";

const env = dotenv.config();

export const PORT = process.env.PORT;

export const mongoDBURL = `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_CLUSTER}`;

EOF
# Creating dotenv example file and writing initial code
cat <<EOF > .env.example
MONGO_DATABASE=
MONGO_USER=
MONGO_PASSWORD=
MONGO_CLUSTER=
PORT=
EOF
# Creating dotenv file and writing initial code
cat <<EOF > .env
MONGO_DATABASE=$DATABASE_NAME
MONGO_USER=$USER_NAME
MONGO_PASSWORD=$PASSWORD
MONGO_CLUSTER=$CLUSTER_NAME
PORT=$PORT_NUMBER
EOF

# Install CORS policy node package
npm i cors || echo "Error installing CORS package"


echo "Backend files and directory created"

# echo "Should we test run the back end? (y or n)"
# read -r TEST_BACKEND
# if [ "${TEST_BACKEND,,}" == "y" ]; then
#   npm run dev
# fi

######### END OF CHANGES IN THE BACKEND DIRECTORY #########


######## START OF CHANGES IN THE FRONTEND DIRECTORY #########
cd ..
npm create vite@latest -y "$PROJECT_NAME"-frontend -- --template react
echo "react app created"
echo "cd into $PROJECT_NAME-frontend"
cd "$PROJECT_NAME"-frontend || echo "Error going into $PROJECT_NAME-frontend directory"
echo "installing node packages..."
sleep 1
npm i || echo "Error node package installation"
echo "Node packages installed"
echo "No need to run cd $PROJECT_NAME-frontend and npm install"

# Installing and initializing Tailwind CSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# SPA and react-router-dom
npm i react-router-dom

cat <<-EOF > tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

cd src || echo "Got into the src directory"
cat <<-EOF > index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

rm App.css

cat <<-EOF > App.jsx
import React from 'react'

const App = () => {
  return (
    <div>App</div>
  )
}

export default App
EOF

######### END OF CHANGES IN THE FRONTEND DIRECTORY #########

  # Project Creation completed
  echo "$PROJECT_NAME project created, Happy coding!"
