import * as admin from "firebase-admin";


admin.initializeApp();

export const auth = import("./services/auth");
export const user = import("./services/user");
export const utils = import("./services/utils");
