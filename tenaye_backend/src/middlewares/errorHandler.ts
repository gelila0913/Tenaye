import { Request, Response, NextFunction } from 'express';

export interface AppError extends Error {
  statusCode?: number;
}

export const errorHandler = (
  err: AppError,
  req: Request,
  res: Response,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  next: NextFunction
) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  console.error(`[Error] ${statusCode} - ${message}\nStack: ${err.stack}`);

  // Prisma unique constraint violation or validation errors handling helper
  if ((err as any).code === 'P2002') {
    return res.status(409).json({
      success: false,
      error: 'ConflictError',
      message: 'A record with that unique value already exists.',
    });
  }

  if ((err as any).code === 'P2025') {
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
