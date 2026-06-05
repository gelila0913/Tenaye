"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const path_1 = __importDefault(require("path"));
const errorHandler_1 = require("./middlewares/errorHandler");
const profileRoutes_1 = __importDefault(require("./routes/profileRoutes"));
const weightRoutes_1 = __importDefault(require("./routes/weightRoutes"));
const nutritionRoutes_1 = __importDefault(require("./routes/nutritionRoutes"));
const fitnessRoutes_1 = __importDefault(require("./routes/fitnessRoutes"));
const chatRoutes_1 = __importDefault(require("./routes/chatRoutes"));
const medicationRoutes_1 = __importDefault(require("./routes/medicationRoutes"));
const moodRoutes_1 = __importDefault(require("./routes/moodRoutes"));
const metricsRoutes_1 = __importDefault(require("./routes/metricsRoutes"));
const routes_1 = __importDefault(require("./modules/sos/routes"));
const app = (0, express_1.default)();
// Global Middlewares
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Serve uploaded progress photos
app.use('/uploads', express_1.default.static(path_1.default.join(process.cwd(), 'uploads')));
// API Feature Module Endpoints Routing
app.use('/api/profile', profileRoutes_1.default);
app.use('/api/weight', weightRoutes_1.default);
app.use('/api/medications', medicationRoutes_1.default);
app.use('/api/mood', moodRoutes_1.default);
app.use('/api/metrics', metricsRoutes_1.default);
app.use('/api/nutrition', nutritionRoutes_1.default);
app.use('/api/fitness', fitnessRoutes_1.default);
app.use('/api/chat', chatRoutes_1.default);
app.use('/api/sos', routes_1.default);
// Basic Sandbox Health Check Verification Anchor
app.get('/health', (_req, res) => {
    res.status(200).json({
        success: true,
        status: 'UP',
        timestamp: new Date().toISOString(),
    });
});
// Global Centralized Error Interception Middleware
app.use(errorHandler_1.errorHandler);
exports.default = app;
