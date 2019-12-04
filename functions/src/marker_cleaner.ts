import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { deleteADoc } from './helper_funcs'

const db = admin.firestore()


//schedule cleanup jobs everyday at 23:0 UTC time to cleanup unscheduled markers
export const markerCleaner = functions.runWith({ memory: '512MB' }).pubsub
    .schedule('23 0 * * *').timeZone("UTC").onRun(async context => {

        //find timestamp for now and convert to seconds
        var serverTimeStmp = admin.firestore.Timestamp.now().seconds
        console.log(`TIME IN seconds -> ${serverTimeStmp}`)

        const query = db.collection('TaggedTrash')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //for each user in the user class, send out the 
        task.forEach(snapshot => {
            const data = snapshot.data()

            //get doc's expiration date 
            var expirationDate = data["expiration_date"]
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