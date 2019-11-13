import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore()
const fcm = admin.messaging();

export const logoutUser = functions.runWith({ memory: '512MB' }).pubsub
    //(* * * * *) runs every 1 minute. look up cron time to learn more
    //at 00:00 each day
    //configure to run at NYC time
    .schedule('0 * * 12 *').timeZone("UTC").onRun(async context => {

        //query and the task to get those queries from firebase
        //need to get the device tokens 
        const query = db.collection('GeofenceData')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //for each user in the user class, send out the logout message
        task.forEach(snapshot => {
            const data = snapshot.data()

            //gotta get today's payload ****might have to re-configure dates on firestore
            let device_token = data["device_token"];

            const payload = {
                notification: {
                    title: "You have been logged-out!"
                },
                data: {
                    "logout": "true"//`${queryDay}`
                }
            };

            var options = {
                contentAvailable: true,
                priority: "high",
                sound: 'false'//turing off sound since user dont need to see it
            };

            // send to each individual device token retrieved from the database
            fcm.sendToDevice(`${device_token}`, payload, options)
                .then((response) => {
                    console.log(response)
                }).catch((error) => {
                    console.log(error)
                });
        })

        return await Promise.all(jobs)

    })