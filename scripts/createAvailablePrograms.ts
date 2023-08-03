import * as admin from "firebase-admin";

admin.initializeApp({
  projectId: "excel-academy-online",
});

const db = admin.firestore();

interface CourseProgramItem {
  color: number;
  initial: string;
  fullName: string;
  assetUrl: string;
  numOfLevels: number;
  numOfCourses: number;
}

const _prefix = [
  "https://firebasestorage.googleapis.com/v0",
  "/b/excel-academy-online.appspot.com",
  "/o/assets%2Fpages%2Fhomepage%2Fprograms%2F",
  "{icon}?alt=media"
].join("");

function getURL(filename: string): string {
  // Implement the logic to get the URL for the given filename
  return _prefix.replace("{icon}", filename);
}

const sampleCoursePrograms: CourseProgramItem[] = [
  {
    initial: "ICAN",
    color: 0xFF0F0BAB,
    fullName: "Institute of Chartered Accountants of Nigeria",
    assetUrl: getURL("ican_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  },
  {
    initial: "ACCA",
    color: 0xFFFF822B,
    fullName: "Association of Chartered Certified Accountants",
    assetUrl: getURL("acca_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  },
  {
    initial: "CIMA",
    color: 0xFF1FAF73,
    fullName: "Chartered Institute of Management Accountants",
    assetUrl: getURL("cima_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  },
  {
    initial: "CITN",
    color: 0xFF9747FF,
    fullName: "Chartered Institute of Taxation of Nigeria",
    assetUrl: getURL("citn_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  },
];

async function main() {
  const batch = db.batch();
  const ref = db.collection("programs");
  sampleCoursePrograms.forEach((item) => {
    const docRef = ref.doc();
    batch.set(docRef, item);
  });
  await batch.commit();
}

if (require.main === module) {
  console.log("Creating available programs...");
  main();
}

