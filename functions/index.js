const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

exports.createUser = functions.firestore
    .document('Meetups/{userId}')
    .onCreate((snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = snap.data();

      console.log("hooray "+ newValue);
      // access a particular field as you would any JS property
      const name = newValue.name;

      // perform desired operations ...
    });
