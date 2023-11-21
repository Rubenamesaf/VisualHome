/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const nodemailer = require("nodemailer");

const gmailEmail = "pepsua47@gmail.com";
const gmailPassword = "vqxt okzh jajy sihp";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

exports.sendEmail = functions.https.onRequest((req, res) => {
  const dest = req.query.dest;
  const codigo = req.query.codigo;

  const mailOptions = {
    from: gmailEmail,
    to: dest,
    subject: "VisualHome - Codigo de recuperacion",
    text: "Codigo de recuperacion: " + codigo,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return res.status(500).send(error.toString());
    }
    return res.status(200).send("Correo enviado: " + info.response);
  });
});