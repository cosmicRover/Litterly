import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

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