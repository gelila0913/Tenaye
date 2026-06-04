import express from 'express';
import cors from 'cors';
import { errorHandler } from './middlewares/errorHandler';
import profileRouter from './modules/profile/routes';
import medicationsRouter from './modules/medications/routes';
import moodRouter from './modules/mood/routes';
import nutritionRouter from './modules/nutrition/routes';
import fitnessRouter from './modules/fitness/routes';
import sosRouter from './modules/sos/routes';

const app = express();

// Global Middlewares
app.use(cors());
app.use(express.json());

// API Feature Module Endpoints Routing
app.use('/api/profile', profileRouter);
app.use('/api/medications', medicationsRouter);
app.use('/api/mood', moodRouter);
app.use('/api/nutrition', nutritionRouter);
app.use('/api/fitness', fitnessRouter);
app.use('/api/sos', sosRouter);

// Basic Sandbox Health Check Verification Anchor
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    status: 'UP',
    timestamp: new Date().toISOString(),
  });
});

// Global Centralized Error Interception Middleware
app.use(errorHandler);

export default app;
