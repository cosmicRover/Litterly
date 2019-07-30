const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firestore);

db = admin.firestore()
let userRef = db.collection('Users');

exports.scheduledFunction = functions.pubsub.schedule('every 1 minutes').onRun((context) => {
    readData();
});

function readData() {
    functions.https.onRequest((request, Response) => {
        userRef.get().then(snapshot => {
            snapshot.forEach(doc => {
                console.log(doc)
            });
        });
        return
    }).catch(err => {
        console.log(err)
        return
    })
}



