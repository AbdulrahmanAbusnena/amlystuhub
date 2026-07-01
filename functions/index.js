
 // * Import function triggers from their respective submodules:

  const {onCall} = require("firebase-functions/v2/https"); 
  const {onDocumentWritten} = require("firebase-functions/v2/firestore"); 
  const admin = require("firebase-admin"); 
  const nodemailer = require("nodemailer");
  
  admin.initializeApp();
  const db = admin.firestore(); 
   
 // configuring the connection to our official StuCo account 

 // cloud function trigger listening to our announcements tigger in firestore 

 // constructing the targeted user query based on announcement criteria
  
 // filtering out students who aren't in the designated target grades array 

 // filter out non-ap students if the flag is checked as true 

 // Guard clause if no students match this specific demographic profile 

 // the structural formatting layout for the student emails  
 
 // sneding the emails to networks stream 


 
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
