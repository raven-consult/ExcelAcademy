import axios from "axios";
import {faker} from "@faker-js/faker";
import * as admin from "firebase-admin";
import {createClient, ErrorResponse} from "pexels";

admin.initializeApp({
  projectId: "excel-academy-online",
  storageBucket: "excel-academy-online.appspot.com",
});

const PEXELS_API_KEY = process.env.PEXELS_API_KEY;

const pexels = createClient(PEXELS_API_KEY);

const auth = admin.auth();
const firestore = admin.firestore();
const storage = admin.storage().bucket();

firestore.settings({
  ignoreUndefinedProperties: true,
} as admin.firestore.Settings);

interface Course {
  title: string;
  price: number;
  rating: number;
  description: string;
  thumbnailUrl: string;
  videos: Array<Video>;
  reviews: Array<Review>;
  students: Array<Student>;
  createdAt: admin.firestore.Timestamp;
}

type Student = string;

interface Video {
  id: string;
  kind: string;
  title: string;
  videoUrl: string;
  duration: number;
  thumbnailUrl: string;
}

interface Review {
  body: string;
  userId: string;
  createdAt: admin.firestore.Timestamp;
}

const createID = () => Math.random().toString(36).substring(2, 15);

const isErrorResponse = (query: any): query is ErrorResponse => {
  return query.hasOwnProperty("error");
}


async function createUser(displayName: string, email: string, photoURL: string, password: string): Promise<Student> {
  const res = await auth.createUser({
    email,
    password,
    photoURL,
    displayName,
  });

  return res.uid;
}

async function createVideo(
  courseId: string,
  title: string,
  kind: "Full" | "Revision",
  videoUrl: string
) {
  const doc = firestore
    .collection("courses")
    .doc(courseId)

  const video = <Video>{
    kind,
    title,
    videoUrl,
  };

  await doc.update({
    videos: admin.firestore.FieldValue.arrayUnion(video),
  });

  return doc.id;
}

async function createReview(courseId: string, review: Review) {
  const doc = firestore
    .collection("courses")
    .doc(courseId);

  await doc.update({
    reviews: admin.firestore.FieldValue.arrayUnion({
      ...review,
      createdAt: admin.firestore.Timestamp.now(),
    } as Review),
  });

  return doc.id;
}
async function createCourse(
  title: string,
  description: string,
  price: number,
  rating: number,
  thumbnailUrl: string,
) {
  const doc = firestore.collection("courses").doc();

  await doc.set(<Course>{
    title,
    description,
    price,
    rating,
    thumbnailUrl,
    videos: [],
    students: [],
    reviews: [],
    createdAt: admin.firestore.Timestamp.now(),
  });
  return doc.id;
}

async function addUserToCourse(courseId: string, userId: string) {
  const doc = firestore
    .collection("courses")
    .doc(courseId);

  await doc.update({
    students: admin.firestore.FieldValue.arrayUnion(userId),
  });

  return doc.id;
}

async function main() {
  const courses = await Promise.all<string>(Array.from({length: 3}).map(async () => {
    // Create course
    const course = await createCourse(
      faker.lorem.sentence(),
      faker.lorem.paragraph(),
      Number.parseFloat(faker.commerce.price({min: 100, max: 200})),
      faker.number.float({min: 0, max: 5, precision: 0.1}),
      faker.image.urlLoremFlickr({category: 'business'}),
    );

    // Download three videos from pexels and upload to course
    await Promise.all(Array.from({length: 3}).map(async () => {
      const query = await pexels.videos.search({query: "business", per_page: 1});

      if (isErrorResponse(query)) {
        throw new Error(query.error);
      }

      if (query.videos.length == 0) {
        throw new Error("No videos found");
      }

      const videoId = createID();
      const file = storage.file(`courses/${course}/videos/${videoId}.mp4`);
      const video = query.videos[0].video_files[0].link;
      const res = await axios.get(video, {responseType: "stream"})

      console.log("Uploading video");
      await new Promise<void>((resolve, reject) => {
        res.data
          .pipe(file.createWriteStream({
            metadata: {
              contentType: "video/mp4",
            }
          }))
          .on("error", () => {
            reject();
          })
          .on("finish", () => {
            resolve();
          });
      });
      console.log("Finished upload");

      await file.makePublic();
      const url = file.publicUrl();

      await createVideo(
        course,
        faker.word.words({count: {min: 5, max: 10}}),
        faker.helpers.arrayElement(["Full", "Revision"]) as "Full" | "Revision",
        url
      );
    }));

    // Create students
    const students = await Promise.all([
      createUser(faker.person.fullName(), faker.internet.email(), faker.image.avatar(), "password"),
      createUser(faker.person.fullName(), faker.internet.email(), faker.image.avatar(), "password"),
      createUser(faker.person.fullName(), faker.internet.email(), faker.image.avatar(), "password"),
      createUser(faker.person.fullName(), faker.internet.email(), faker.image.avatar(), "password"),
    ])
    await Promise.all(students.map(async (student) => addUserToCourse(course, student)));

    // Create reviews
    await Promise.all([
      createReview(course, {body: faker.lorem.paragraph(), userId: faker.helpers.arrayElement(students), createdAt: admin.firestore.Timestamp.now()}),
      createReview(course, {body: faker.lorem.paragraph(), userId: faker.helpers.arrayElement(students), createdAt: admin.firestore.Timestamp.now()}),
      createReview(course, {body: faker.lorem.paragraph(), userId: faker.helpers.arrayElement(students), createdAt: admin.firestore.Timestamp.now()}),
      createReview(course, {body: faker.lorem.paragraph(), userId: faker.helpers.arrayElement(students), createdAt: admin.firestore.Timestamp.now()}),
    ]);

    return course;
  }));

  console.log(courses);
}

main();
