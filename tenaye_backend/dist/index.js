"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = __importDefault(require("./app"));
const database_1 = require("./config/database");
const PORT = process.env.PORT || 3000;
async function main() {
    try {
        // 1. Verify database connection is active before server starts listening
        await database_1.prisma.$connect();
        console.log('Successfully connected to PostgreSQL database via Prisma.');
        // 2. Open HTTP Server listener binding loop
        app_1.default.listen(PORT, () => {
            console.log(`Tenaye backend server is running on port ${PORT}`);
            console.log(`Health check: http://localhost:${PORT}/health`);
        });
    }
    catch (error) {
        console.error('Fatal error during backend initialization:', error);
        await database_1.prisma.$disconnect();
        process.exit(1);
    }
}
main();
