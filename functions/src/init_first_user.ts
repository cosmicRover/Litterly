import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { resetADoc } from './helper_funcs'

const db = admin.firestore()

interface PointsDataModel{
    cumulative_points: number,
    total_points: number
}

interface GeofenceDataModel{
    user_id: string,
    device_token: string,
    monday: [{"lat":number, "lon":number}],
    tuesday: [{ "lat": number, "lon": number }],
    wednesday: [{ "lat": number, "lon": number }],
    thursday: [{ "lat": number, "lon": number }],
    friday: [{ "lat": number, "lon": number }],
    saturday: [{ "lat": number, "lon": number }],
    sunday: [{ "lat": number, "lon": number }],
    monday_count: number,
    tuesday_count: number,
    wednesday_count: number,
    thursday_count: number,
    friday_count: number,
    saturday_count: number,
    sunday_count: number
}


export const initFirstUser = functions.firestore.document("Users/{id}").onCreate(async (snapshot, context) => {

    //get the created docId
    const docId: string = snapshot.id.toString()
    console.log(`just crated document user -> ${docId}`)
    //jobs to execute
    const jobs: Promise<any>[] = []

    //prep the refs
    const pointsRef = db.collection('Points').doc(docId)
    const fenceTriggerRef = db.collection('GeofenceTriggerTimes').doc(docId)
    const fenceDataRef = db.collection('GeofenceData').doc(docId)

    //await the results
    const pointsResponse = await pointsRef.get()
    const fenceTrigResponse = await fenceTriggerRef.get()
    const fenceDataResponse = await fenceDataRef.get()
    
    //make decisions
    if (!pointsResponse.exists){
        console.log('Points dont exist')
        const data:PointsDataModel ={
            cumulative_points: 0,
            total_points: 0
        } 
        
        jobs.push(
            writePointsPlaceholderDocuments("Points", docId, data)
        )
    }

    if (!fenceTrigResponse.exists){
        console.log('fenceTrig dont exist')
        jobs.push(
            resetADoc("GeofenceTriggerTimes", docId)
        )
    }

    if (!fenceDataResponse.exists){
        console.log('fenceData dont exist')
        const placeholderFenceData:GeofenceDataModel = {
            user_id: docId,
            device_token: "",
            monday: [{"lon":0, "lat": 0}],
            tuesday: [{ "lon": 0, "lat": 0 }],
            wednesday: [{ "lon": 0, "lat": 0 }],
            thursday: [{ "lon": 0, "lat": 0 }],
            friday: [{ "lon": 0, "lat": 0 }],
            saturday: [{ "lon": 0, "lat": 0 }],
            sunday: [{ "lon": 0, "lat": 0 }],
            monday_count: 0,
            tuesday_count: 0,
            wednesday_count: 0,
            thursday_count: 0,
            friday_count: 0,
            saturday_count: 0,
            sunday_count: 0
        }

        jobs.push(
            writeFenceDataPlaceholderDocuments("GeofenceData", docId, placeholderFenceData)
        )
    }
})

function writeFenceDataPlaceholderDocuments(collectionId: string, docId: string, dict:GeofenceDataModel) {
    console.log("setting fence-data docs")
    const ref = db.collection(collectionId).doc(docId)
    return ref.set(dict)
}

function writePointsPlaceholderDocuments(collectionId: string, docId: string, dict: PointsDataModel) {
    console.log("setting ponits docs")
    const ref = db.collection(collectionId).doc(docId)
    return ref.set(dict)
}
