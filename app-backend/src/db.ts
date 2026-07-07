import { MongoClient, ObjectId, Collection } from 'mongodb';

const { MONGO_USER, MONGO_PASSWORD, MONGO_HOST, MONGO_DB } = process.env;
const mongoUrl = `mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:27017/${MONGO_DB}?authSource=${MONGO_DB}`;

console.log('Connecting to MongoDB:', mongoUrl);
const dbName = MONGO_DB;
const collectionName = 'subjects';

let subjectsCollection: Collection;

export async function connectDB() {
  try {
    const client = new MongoClient(mongoUrl);
    await client.connect();

    const db = client.db(dbName);
    subjectsCollection = db.collection(collectionName);
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
    process.exit(1);
  }
}

export async function getSubjects() {
  const subjects = await subjectsCollection.find({}).toArray();
  return subjects.map((s: any) => ({
    objectId: s._id.toString(),
    name: s.name
  }));
}

export async function createSubject(name: string) {
  const result = await subjectsCollection.insertOne({ name });
  return {
    objectId: result.insertedId.toString(),
    name,
  };
}

export async function deleteSubject(id: string) {
  const result = await subjectsCollection.deleteOne({ _id: new ObjectId(id) });
  return result.deletedCount > 0;
}
