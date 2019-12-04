import * as admin from 'firebase-admin';
//init app
admin.initializeApp();

//import the cloud functions
import { logoutUser } from './logout'
import { addExpirationDate } from './add_expiration_date'
import { awardPoints } from './award_points'
import { meetupCleaner } from './meetup_cleaner'
import { markerCleaner } from './marker_cleaner'
import { taskRunner } from './send_geofence'
import { initFirstUser } from './init_first_user'

//formally export them
export { logoutUser }
export { addExpirationDate }
export { awardPoints }
export { meetupCleaner }
export { markerCleaner }
export { taskRunner }
export { initFirstUser }





