import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { incrementPoints, resetADoc } from './helper_funcs'

const db = admin.firestore()

//schedule awarding points jobs everyday at 22:0 UTC time 
export const awardPoints = functions.runWith({ memory: '512MB' }).pubsub
    .schedule('22 0 * * *').timeZone("UTC").onRun(async context => {

        //find timestamp for now inseconds. Keeping it at seconnds 
        //since app sends in seconds
        var serverTimeStmp = admin.firestore.Timestamp.now().seconds
        console.log(`TIME IN seconds -> ${serverTimeStmp}`)

        const query = db.collection('GeofenceTriggerTimes')
        const task = await query.get();

        //jobs to execute
        const jobs: Promise<any>[] = []

        //
        task.forEach(snapshot => {
            //these may change at any time
            //*
            const expectedMeetupDuration = 5
            const pointsRatePerMeetup = 20
            //*
            const data = snapshot.data()
            const docId = snapshot.id
            var pointsToAward = 0

            //use a for loop to find the matching pairs
            for (let i = 1; i <= 10; i++) {

                //since snapshot is a dictionary we do a lookup in constant time to see if a complete timestamp exists
                //e.g. insideTrigger and outsideTrigger
                if ((data[`insideAtregion${i}`]) && (data[`outsideAtregion${i}`])) {
                    var timeSpent = data[`outsideAtregion${i}`] - data[`insideAtregion${i}`]
                    timeSpent = timeSpent / 60 // time spent in minutes
                    console.log(`time spent from region ${i} is ${timeSpent}, docId -> ${docId}`)

                    //determine how mnay points the user had earned
                    switch (true) {
                        case (timeSpent >= expectedMeetupDuration): {
                            pointsToAward += pointsRatePerMeetup
                        }

                        case ((timeSpent < expectedMeetupDuration) && (timeSpent >= expectedMeetupDuration / 2)): {
                            pointsToAward += pointsRatePerMeetup / 2
                        }

                        case (timeSpent < expectedMeetupDuration / 2): {
                            pointsToAward += pointsRatePerMeetup / timeSpent
                        }
                    }
                    console.log(`POINTS TO AWARD ---->>> ${~~pointsToAward}`)
                }
            }
            //award the point to the user
            if (pointsToAward != 0) {
                jobs.push(incrementPoints("Points", docId, pointsToAward | 0))
            }

            //reset the trigger collection 
            jobs.push(resetADoc('GeofenceTriggerTimes', docId))

        })

        return await Promise.all(jobs)
    })