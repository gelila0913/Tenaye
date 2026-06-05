import express from 'express';
import cors from 'cors';
import path from 'path';
import { errorHandler } from './middlewares/errorHandler';
import profileRouter from './routes/profileRoutes';
import weightRouter from './routes/weightRoutes';
import nutritionRouter from './routes/nutritionRoutes';
import fitnessRouter from './routes/fitnessRoutes';
import chatRouter from './routes/chatRoutes';
import medicationsRouter from './modules/medications/routes';
import moodRouter from './modules/mood/routes';
import sosRouter from './modules/sos/routes';

const app = express();

// Global Middlewares
app.use(cors());
app.use(express.json());

// Serve uploaded progress photos
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

// API Feature Module Endpoints Routing
app.use('/api/profile', profileRouter);
app.use('/api/weight', weightRouter);
app.use('/api/medications', medicationsRouter);
app.use('/api/mood', moodRouter);
app.use('/api/nutrition', nutritionRouter);
app.use('/api/fitness', fitnessRouter);
app.use('/api/chat', chatRouter);
app.use('/api/sos', sosRouter);

// Basic Sandbox Health Check Verification Anchor
app.get('/health', (_req, res) => {
  res.status(200).json({
    success: true,
    status: 'UP',
    timestamp: new Date().toISOString(),
  });
});

// Global Centralized Error Interception Middleware
app.use(errorHandler);

export default app;
