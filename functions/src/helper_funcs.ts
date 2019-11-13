import * as admin from 'firebase-admin';

const db = admin.firestore()

//helper function to delete a document from tagged trash
export function deleteADoc(collectionId: string, docID: string) {
    console.log("DELETING DOCS")
    return db.collection(collectionId).doc(docID).delete()
}

//helper function to increment user points
export function incrementPoints(collectionId: string, docID: string, points: number) {
    console.log("incrementing user points")
    const increment = admin.firestore.FieldValue.increment(points)
    const ref = db.collection(collectionId).doc(docID)
    return ref.update({ cumulative_points: increment, total_points: increment })
}

//helper function to delete a document from tagged trash
export function resetADoc(collectionId: string, docID: string) {
    console.log("Reseting doc")
    const ref = db.collection(collectionId).doc(docID)
    return ref.set({ dont: "delete" })
}