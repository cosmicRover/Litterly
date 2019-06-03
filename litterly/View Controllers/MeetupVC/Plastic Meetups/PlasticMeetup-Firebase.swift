import Foundation
import FirebaseFirestore

extension PlasticMeetupViewController{
    
    func fetchPlasticMeetups(){
        
        let plasticMeetupQuery = sharedValues.db.collection("Meetups").whereField("type_of_trash", isEqualTo: "plastic")
        
        plasticMeetupQuery.getDocuments(){
            QuerySnapshot, Error in
            
            guard let snapShot = QuerySnapshot else {return}
            
            snapShot.documents.forEach{
                data in
                
                let meetupAddress = data["meetup_address"] as! String
                let meetupDateAndTime = data["meetup_date_time"] as! String
                
                let dataToAppend = MeetupsQueryModel(meetup_address: meetupAddress, meetup_date_time: meetupDateAndTime, type_of_trash: "")
                
                self.queriedMeetupArray.append(dataToAppend)
                
                print(self.queriedMeetupArray)
                
                self.embeddedTableview.reloadData()
                
            }
            
            
        }
        
    }
}
