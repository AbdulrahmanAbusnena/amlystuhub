
 // * Import function triggers from their respective submodules:

  const {onCall} = require("firebase-functions/v2/https"); 
  const {onDocumentWritten, onDocumentCreated} = require("firebase-functions/v2/firestore"); 
  const admin = require("firebase-admin"); 
  const nodemailer = require("nodemailer");
  
  admin.initializeApp();
  const db = admin.firestore(); 
   
 // configuring the connection to our official StuCo account  
 const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "abdulrahman.abosnina@stu.amly.us", 
    pass: "4risewire2" 
  } 
}); 

 // cloud function trigger listening to our announcements trigger in firestore 
exports.sendTargetedAnnouncementEmail = onDocumentCreated("announcements/{docId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) return null;

  const announcement = snapshot.data() || {};
  const targetGrades = Array.isArray(announcement.targetGrades) ? announcement.targetGrades : [];
  const apOnly = announcement.apOnly === true;
  const subject = announcement.subject || "New Announcement";
  const message = announcement.message || announcement.body || "";

  let usersQuery = db.collection("users");

  if (targetGrades.length > 0) {
    usersQuery = usersQuery.where("gradeLevel", "in", targetGrades);
  }

  if (apOnly) {
    usersQuery = usersQuery.where("isApStudent", "==", true);
  }

  try {
    const usersSnapshot = await usersQuery.get();
    const recipientEmails = [];

    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      if (userData && userData.email) {
        recipientEmails.push(userData.email);
      }
    });

    if (recipientEmails.length === 0) {
      return null;
    }

    const mailOptions = {
      from: '"StuCo" <abdulrahman.abosnina@stu.amly.us>',
      to: recipientEmails,
      subject,
      text: message,
    };

    await transporter.sendMail(mailOptions);
    return { success: true, recipients: recipientEmails.length };
  } catch (error) {
    console.error("sendTargetedAnnouncementEmail error", error);
    return { success: false, error: error.message };
  }
});

 
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
