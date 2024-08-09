import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import { Pool } from 'pg';

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

const pool = new Pool({
    user: 'your_username',
    host: 'localhost',
    database: 'your_database',
    password: 'your_password',
    port: 5432,
});

app.post('/calculate-sip', async (req, res) => {
    const { monthlyInvestment, rateOfReturn, investmentPeriod } = req.body;
    const r = rateOfReturn / 12 / 100;
    const n = investmentPeriod * 12;
    const maturityValue = monthlyInvestment * (Math.pow(1 + r, n) - 1) / r * (1 + r);
    res.json({ maturityValue: maturityValue.toFixed(2) });
});

// Root endpoint
app.get('/', (req, res) => {
    res.send('Welcome to the SIP Calculator API!');
});

// Start server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
