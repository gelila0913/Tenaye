"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
const errorHandler = (err, req, res, 
// eslint-disable-next-line @typescript-eslint/no-unused-vars
next) => {
    const statusCode = err.statusCode || 500;
    const message = err.message || 'Internal Server Error';
    console.error(`[Error] ${statusCode} - ${message}\nStack: ${err.stack}`);
    // Prisma unique constraint violation or validation errors handling helper
    if (err.code === 'P2002') {
        return res.status(409).json({
            success: false,
            error: 'ConflictError',
            message: 'A record with that unique value already exists.',
        });
    }
    if (err.code === 'P2025') {
        return res.status(404).json({
            success: false,
            error: 'NotFoundError',
            message: 'The requested record was not found in the database.',
        });
    }
    res.status(statusCode).json({
        success: false,
        error: err.name || 'ServerError',
        message,
        ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
    });
};
exports.errorHandler = errorHandler;
