import 'dotenv/config';
import express, { type Request, type Response } from 'express';
import cors from 'cors';
import { connectDB, getSubjects, createSubject, deleteSubject } from './db.ts';

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.get('/api/subject', async (req: Request, res: Response) => {
  try {
    const subjects = await getSubjects();
    res.json(subjects);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching subjects' });
  }
});

app.post('/api/subject', async (req: Request, res: Response) => {
  const { name } = req.body;

  try {
    const newSubject = await createSubject(name);
    res.status(201).json(newSubject);
  } catch (error) {
    res.status(500).json({ error: 'Error creating subject' });
  }
});

app.delete('/api/subject/:id', async (req: Request, res: Response) => {
  const { id } = req.params as { id: string };

  try {
    await deleteSubject(id);
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Error deleting subject' });
  }
});

connectDB().then(() => {
  app.listen(port, () => {
    console.log(`Server started in port [${port}]`);
  });
});