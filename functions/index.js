
 // * Import function triggers from their respective submodules:

  const {onCall} = require("firebase-functions/v2/https"); 
  const {onDocumentWritten} = require("firebase-functions/v2/firestore"); 
  const admin = require("firebase-admin"); 
  const nodemailer = require("nodemailer");
  
  admin.initializeApp();
  const db = admin.firestore(); 
  
 
 
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
