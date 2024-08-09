"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const body_parser_1 = __importDefault(require("body-parser"));
const cors_1 = __importDefault(require("cors"));
const pg_1 = require("pg");
const app = (0, express_1.default)();
const port = 3000;
// Middleware
app.use((0, cors_1.default)());
app.use(body_parser_1.default.json());
// PostgreSQL connection
const pool = new pg_1.Pool({
    user: 'your_username',
    host: 'localhost',
    database: 'your_database',
    password: 'your_password',
    port: 5432,
});
// Example route to get SIP calculations
app.post('/calculate-sip', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { monthlyInvestment, rateOfReturn, investmentPeriod } = req.body;
    // Calculate the SIP maturity value (you can store these in the database if needed)
    const r = rateOfReturn / 12 / 100;
    const n = investmentPeriod * 12;
    const maturityValue = monthlyInvestment * (Math.pow(1 + r, n) - 1) / r * (1 + r);
    res.json({ maturityValue: maturityValue.toFixed(2) });
}));
// Start server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
