import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore()

//**note** /{id} is a wildcard which monitors for any new document creation
//**note** that timestamp is in UTC time
export const addExpirationDate = functions.firestore.document("TaggedTrash/{id}").onCreate(async (snapshot, context) => {

    //step 1 get the created docId
    const docId: String = snapshot.id.toString()
    console.log(`just crated document id -> ${docId}`)

    //step 2 get today's date and increment it forward 7 days at 00:00:00
    var initTimeStmp = admin.firestore.Timestamp.now()
    const initDateValue = initTimeStmp.toDate()
    console.log(`Init time value -->> ${initDateValue}`)

    var date = new Date()
    date.setDate(initDateValue.getDate() + 7)
    date.setHours(0, 0, 0, 0)
    console.log(`ADDED days -->> ${date}`)

    //step 3 convert the new date to firestore timestamp
    const timeStmp = admin.firestore.Timestamp.fromDate(date)
    const value = timeStmp.seconds
    console.log(`FIREBASE timestamp -->> ${value}`)

    //step 4 update expiration key to the timestamp
    var batch = db.batch()
    var ref = db.collection('TaggedTrash').doc(`${docId}`)
    // const dataToUpdate = 
    batch.update(ref, { "expiration_date": value })

    await batch.commit();
})