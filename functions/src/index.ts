import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

//init admin and fcm for cloud messaging
admin.initializeApp();
const db = admin.firestore()
const fcm = admin.messaging();

export const taskRunner = functions.runWith({ memory: '1GB' }).pubsub
    //(* * * * *) runs every 1 minute. look up cron time to learn more
    .schedule('* * * * *').onRun(async context => {

        //get today's day
        const now = Date();
        const day = now.split(" ");
        console.log("Now is ->> ", day[0]);
        const today = day[0];
        var queryDay = ""

        switch (today) {
            case "Sun":
                queryDay = "monday"
                break
            case "Mon":
                queryDay = "tuesday"
                break
            case "Tue":
                queryDay = "wednesday"
                break
            case "Wed":
                queryDay = "thursday"
                break
            case "Thu":
                queryDay = "friday"
                break
            case "Fri":
                queryDay = "Saturday"
                break
            case "Sat":
                queryDay = "Sunday"
                break

        };

        //query and the task to get those queries from firebase
        //need to get the device tokens + today's geofence payload
        const query = db.collection('GeofenceData');
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = [];

        //for each user in the user class, send out the 
        task.forEach(snapshot => {
            const data = snapshot.data();

            //gotta get today's payload ****might have to re-configure dates on firestore
            let device_token = data["device_token"];

            //only send fcm if count > 0
            let day_count = data[`${queryDay}` + "_count"]

            console.log(device_token, day_count)


            //follow the silent message composing format to send silent messages
            //insert payload into the message
            const payload = {
                notification: {
                    title: "Your meetups are ready!",
                    body: "Tap me to confirm!"
                },
                data: {
                    "day": `friday`//`${queryDay}`
                }
            };

            //need to specify options and priority
            var options = {
                contentAvailable: true,
                priority: "high"
            };

            // console.log(name);

            // var message = {
            //     notification: {
            //         title: '$GOOG up 1.43% on the day',
            //         body: '$GOOG gained 11.80 points to close at 835.67, up 1.43% on the day.'
            //     },
            //     condition: condition
            // };

            // send to each individual device token retrieved from the database
            fcm.sendToDevice(`${device_token}`, payload, options)
                .then((response) => {
                    console.log(response)
                }).catch((error) => {
                    console.log(error)
                });
        });

        return await Promise.all(jobs);

    });



