import app from './app';
import { prisma } from './config/database';

const PORT = process.env.PORT || 3000;

async function main() {
  try {
    // 1. Verify database connection is active before server starts listening
    await prisma.$connect();
    console.log('Successfully connected to PostgreSQL database via Prisma.');

    // 2. Open HTTP Server listener binding loop
    app.listen(PORT, () => {
      console.log(`Tenaye backend server is running on port ${PORT}`);
      console.log(`Health check: http://localhost:${PORT}/health`);
    });
  } catch (error) {
    console.error('Fatal error during backend initialization:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

main();
