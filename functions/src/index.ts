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
        const today =

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
            let today_payload = data["${day[0]}"]




            //follow the silent message composing format to send silent messages
            //insert payload into the message
            const payload: admin.messaging.MessagingPayload = {

                notification: {
                    title: 'Test from cloud functions',
                    body: '${name} is here!!',
                    icon: 'https://i.pinimg.com/originals/15/a3/0e/15a30e80a28dca1e25dd7c25156c6054.gif'
                }

            };

            console.log(name);

            // var message = {
            //     notification: {
            //         title: '$GOOG up 1.43% on the day',
            //         body: '$GOOG gained 11.80 points to close at 835.67, up 1.43% on the day.'
            //     },
            //     condition: condition
            // };

            // send to each individual device token retrieved from the database
            fcm.sendToDevice("es5664oO_m0:APA91bFixdr4Ug49Lby4J_FEGeZ_CZuhJPjOpMwEWr2cWkV-qP6j0x6sI1E0UEfT58sXidTjZCVo8A3ffDNu9f2gKUab97hvivrV_MLAkrlVymbV8okL31EHYuSwTFbxqiPX2Cr7YYVU", payload)
                .then((response) => {
                    console.log(response)
                }).catch((error) => {
                    console.log(error)
                });
        });

        return await Promise.all(jobs);

    });



