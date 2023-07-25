import * as admin from "firebase-admin";

admin.initializeApp();

export * as auth from "./services/auth";
export * as user from "./services/user";
export * as utils from "./services/utils";
