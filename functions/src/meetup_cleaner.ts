import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { deleteADoc } from './helper_funcs'

const db = admin.firestore()

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