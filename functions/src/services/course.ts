import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

const db = admin.database();

/**
 * Create a new recommendations document for that course
 */
export const onCourseCreate = functions
  .firestore.document("courses/{courseId}")
  .onCreate(async (snapshot) => {
    const courseRef = snapshot.id;

    await db.ref("recommendations").child(courseRef).set({
      id: courseRef,
      numOfEnrollements: 0,
    });

    functions.logger.log("Recommendations document created for course", courseRef);
  });
