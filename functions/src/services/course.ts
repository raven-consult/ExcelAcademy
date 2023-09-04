import axios from "axios";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import {Course} from "../types";

const db = admin.database();

const url = "https://indexer-gdw5iipadq-uc.a.run.app";

/**
 * Create a new recommendations document for that course
 */
export const onCourseCreate = functions
  .firestore.document("courses/{courseId}")
  .onCreate(async (snapshot) => {
    const courseRef = snapshot.id;
    const courseData = snapshot.data() as Course;

    await Promise.all([
      updateSearchIndex({ ...courseData, courseId: courseRef }),
      addCourseToRecommendations(courseRef),
    ]);
  });

const addCourseToRecommendations = async (courseRef: string) => {
  await db.ref("recommendations").child(courseRef).set({
    id: courseRef,
    numOfEnrollements: 0,
  });
  functions.logger.log("Recommendations document created for course", courseRef);
}


const updateSearchIndex = async (course: Course) => {
  await axios.post(url, course);
  functions.logger.log("Search index updated for course", course);
}
