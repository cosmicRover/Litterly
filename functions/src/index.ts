import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

//init admin and fcm for cloud messaging
admin.initializeApp();
const db = admin.firestore()
const fcm = admin.messaging();

export const taskRunner = functions.runWith({ memory: '512MB' }).pubsub
    //(* * * * *) runs every 1 minute. look up cron time to learn more
    //at 00:00 each day
    //configure to run at NYC time
    .schedule('0 0 * * *').timeZone("America/New_York").onRun(async context => {

        //get today's day
        const now = Date()
        const day = now.split(" ")
        console.log("Now is ->> ", day[0])
        const today = day[0]
        var queryDay = ""
        var queryDayCount = ""
        var exception = ["token_not_found", "account_signed_out"]

        //setup today's query vars
        switch (today) {
            case "Mon":
                queryDay = "monday"
                queryDayCount = "monday_count"
                break
            case "Tue":
                queryDay = "tuesday"
                queryDayCount = "tuesday_count"
                break
            case "Wed":
                queryDay = "wednesday"
                queryDayCount = "wednesday_count"
                break
            case "Thu":
                queryDay = "thursday"
                queryDayCount = "thursday_count"
                break
            case "Fri":
                queryDay = "friday"
                queryDayCount = "friday_count"
                break
            case "Sat":
                queryDay = "saturday"
                queryDayCount = "saturday_count"
                break
            case "Sun":
                queryDay = "sunday"
                queryDayCount = "sunday_count"
                break

        };

        //query and the task to get those queries from firebase
        //need to get the device tokens + today's geofence payload
        const query = db.collection('GeofenceData')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //for each user in the user class, send out the 
        task.forEach(snapshot => {
            const data = snapshot.data()

            //gotta get today's payload ****might have to re-configure dates on firestore
            let device_token = data["device_token"];

            //only send fcm if count > 0
            let day_count = data[`${queryDayCount}`];

            console.log(device_token, day_count, queryDay, queryDayCount)

            //make exception
            if (day_count > 0 && data["device_token"] != exception) {
                //follow the silent message composing format to send silent messages
                //insert payload into the message
                const payload = {
                    notification: {
                        title: "Your meetups are ready.",
                        body: "Tap me to confirm!"
                    },
                    data: {
                        "day": `${queryDay}`//`${queryDay}`
                    }
                };

                //need to specify options and priority
                var options = {
                    contentAvailable: true,
                    priority: "high"
                };

                // send to each individual device token retrieved from the database
                fcm.sendToDevice(`${device_token}`, payload, options)
                    .then((response) => {
                        console.log(response)
                    }).catch((error) => {
                        console.log(error)
                    });
            }
        });

        return await Promise.all(jobs)

    })

//**note** /{id} is a wildcard which monitors for any new document creation
//**note** that timestamp is in UTC time
export const addExpirationDate = functions.firestore.document("TaggedTrash/{id}").onCreate((snapshot, context) => {

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
    const value = timeStmp.toDate()
    console.log(`FIREBASE timestamp -->> ${value}`)

    //step 4 update expiration key to the timestamp
    var batch = db.batch()
    var ref = db.collection('TaggedTrash').doc(`${docId}`)
    // const dataToUpdate = 
    batch.update(ref, { "expiration_date": value })

    return batch.commit().then(function () {
        //add success/error message
    })
})

//schedule cleanup jobs everyday 1t 0:0 UTC time to cleanup unscheduled markers
export const markerCleaner = functions.runWith({ memory: '512MB' }).pubsub
    .schedule('23 0 * * *').timeZone("UTC").onRun(async context => {

        //find timestamp for now and convert to miliSecs
        var serverTimeStmp = admin.firestore.Timestamp.now().toMillis()
        console.log(`TIME IN MILLLLI -> ${serverTimeStmp}`)

        const query = db.collection('TaggedTrash')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //for each user in the user class, send out the 
        task.forEach(snapshot => {
            const data = snapshot.data()

            //get doc's expiration date and convert to milis
            var expirationDate = data["expiration_date"]
            expirationDate = expirationDate.toMillis()
            console.log(`document exp date ----->> ${expirationDate}`)

            const docId = data["id"]
            const meetupStatus = data["is_meetup_scheduled"]

            if (serverTimeStmp >= expirationDate && !meetupStatus) {
                jobs.push(
                    deleteADoc("TaggedTrash", docId)
                )
            }
        })

        return await Promise.all(jobs)

    })


//schedule cleanup jobs everyday 1t 0:0 UTC time to cleanup unscheduled markers
export const meetupCleaner = functions.runWith({ memory: '512MB' }).pubsub
    .schedule('23 0 * * *').timeZone("UTC").onRun(async context => {

        //find timestamp for now inseconds. Keeping it at seconnds 
        //since app sends in seconds
        var serverTimeStmp = admin.firestore.Timestamp.now().seconds
        console.log(`TIME IN seconds -> ${serverTimeStmp}`)

        const query = db.collection('Meetups')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //for each user in the user class, send out the 
        task.forEach(snapshot => {
            const data = snapshot.data()

            //get doc's expiration date and convert to milis
            var expirationValue = data["UTC_meetup_time_and_expiration_time"]
            console.log(`meetup document exp date ----->> ${expirationValue}`)
            const meetupDocId = data["meetup_id"]
            const parentMarkerId = data["parent_marker_id"]

            if (serverTimeStmp >= expirationValue) {
                jobs.push(deleteADoc("Meetups", meetupDocId))
                jobs.push(deleteADoc("TaggedTrash", parentMarkerId))
            }
        })

        return await Promise.all(jobs)

    })

//helper function to delete a document from tagged trash
function deleteADoc(collectionId: string, docID: string) {
    console.log("DELETING DOCS")
    return db.collection(collectionId).doc(docID).delete()
}


