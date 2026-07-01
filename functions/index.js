
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
 if (recipientEmails.length === 0) {
      console.log("No matching student emails found for this target criteria.");
      return null;
    } 

 // the structural formatting layout for the student emails  
  const mailOptions = {
      from: '"AMLY Stuco Hub" <your-stuco-email@gmail.com>',
      bcc: recipientEmails, // Crucial: Always use BCC so students can't see each other's emails
      subject: `[${category.toUpperCase()}] ${title}`,
      html: `
        <div style="font-family: sans-serif; padding: 20px; color: #333;">
          <h2 style="color: #1a73e8; margin-bottom: 5px;">${title}</h2>
          <p style="font-size: 12px; color: #666; margin-top: 0;">Category: <b>${category}</b></p>
          <hr style="border: 0; border-top: 1px solid #eee;" />
          <p style="font-size: 15px; line-height: 1.6;">${content.replace(/\n/g, '<br>')}</p>
          <hr style="border: 0; border-top: 1px solid #eee;" />
          <p style="font-size: 11px; color: #999;">Broadcasted by ${authorName} (${authorRole}) via Stuco Hub Terminal.</p>
        </div>
      `
    }; 
 // sneding the emails to networks stream 


 
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
