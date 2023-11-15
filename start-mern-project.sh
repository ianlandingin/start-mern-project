#!/bin/bash
echo "Starting MERN Project"

echo "Make sure you are reading README.md before you continue (y or n)"
read -r ANSWER

if [ ! ${ANSWER,,} == "y" ]; then
  if [ ! ${ANSWER,,} == "n" ]; then
    echo 'Please enter "y" or "n"'
    exit
  fi
  echo "open README.md before running this script"
  exit
fi

echo "What should we name the project? (ex. no-spaces, No-Spaces)"

read -r PROJECT_NAME

if [ ! ${PROJECT_NAME,,} ]; then
  echo "Please put a project name"
else
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
  # npm i express nodemon || echo "Error installing express and nodemon"
  # npm i mongoose || echo "Error installing mongoose"
  # npm i dotenv || echo "Error installing dotenv"
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

const app = express();

// Middleware for parsing body
app.use(express.json());

app.get("/", (request, response) => {
  console.log(request);
  return response
    .status(234)
    .send("Welcome to your first API endpoint in nodejs");
});

// Add your endpoint codes here


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
# Creating dotenv file and writing initial code
  cat <<EOF > .env
MONGO_DATABASE=
MONGO_USER=
MONGO_PASSWORD=
MONGO_CLUSTER=
PORT=
EOF
# Creating config.js file and writing initial code
  cp .env .env.example || echo "Error creating env.example file"

######### END OF CHANGES IN THE BACKEND DIRECTORY #########


######## START OF CHANGES IN THE FRONTEND DIRECTORY #########
cd ..
npm create vite@latest -y "$PROJECT_NAME"-frontend
cd "$PROJECT_NAME"-frontend || echo "Error going into $PROJECT_NAME-frontend directory"
npm i || echo "Error node package installation"

######### END OF CHANGES IN THE FRONTEND DIRECTORY #########

  # Project Creation completed
  echo "$PROJECT_NAME project created, Happy coding!"
fi