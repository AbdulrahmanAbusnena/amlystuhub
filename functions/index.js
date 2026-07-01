
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
    user: "abdulrahmanabusnena01@gmail.com", 
    pass: "kzbq zkxf zwfz mlgf", 

  } 
}); 

 // cloud function trigger listening to our announcements trigger in firestore 
exports.sendTargetedAnnouncementEmail = onDocumentCreated("announcements/{docId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) return null;

  const announcement = snapshot.data() || {}; 

  const title = announcement.title || "New StuCo Broadcast";
  const content = announcement.content || "";
  const category = announcement.category || "General";
  const authorName = announcement.authorName || "StuCo Admin";
  const authorRole = announcement.authorRole || ""; 

  const targetGrades = Array.isArray(announcement.targetGrades) ? announcement.targetGrades : [];
  const apOnly = announcement.apOnly === true; 




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
      console.log("No matching student emails found.");
      return null;
    }

    const mailOptions = {
      from: '"StuCo Hub Broadcast" <abdulrahmanabusnena01@gmail.com>',
      bcc: recipientEmails, 
      subject: `[${category.toUpperCase()}] ${title}`,
      text: `Broadcast by ${authorName} (${authorRole}):\n\n${content}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; padding: 20px; color: #333;">
          <h2 style="color: #1a73e8; margin-top: 0;">${title}</h2>
          <p style="font-size: 12px; color: #666;">Category: <b>${category}</b></p>
          <hr style="border: 0; border-top: 1px solid #eee;" />
          <p style="font-size: 15px; line-height: 1.6; white-space: pre-line;">${content}</p>
          <hr style="border: 0; border-top: 1px solid #eee;" />
          <p style="font-size: 11px; color: #999;">Sent by ${authorName} (${authorRole}) via StuCo Hub Terminal.</p>
        </div>
      `
    };

    await transporter.sendMail(mailOptions);
    console.log(`Email broadcast sent to ${recipientEmails.length} students.`);
    
  } catch (error) { // ✅ Attached directly to the closing brace above!
    console.error("sendTargetedAnnouncementEmail error", error);
  }  
  return null; 
});

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
