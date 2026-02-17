const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const pool = new Pool({
    host: process.env.DB_HOST || 'postgres',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'devops',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
});

// Test database connection
pool.query('SELECT NOW()', (err, res) => {
    if (err) {
        console.error('❌ Database connection error:', err.message);
    } else {
        console.log('✅ Database connected at:', res.rows[0].now);
    }
});

// Create items table if not exists
pool.query(`
  CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
`, (err) => {
    if (err) {
        console.error('Error creating table:', err.message);
    } else {
        console.log('✅ Items table ready');
    }
});

// Routes
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

app.get('/api', (req, res) => {
    res.json({
        message: 'DevOps API',
        version: '1.0.0',
        endpoints: {
            health: '/health',
            items: '/api/items'
        }
    });
});

app.get('/api/items', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM items ORDER BY created_at DESC');
        res.json({
            success: true,
            count: result.rows.length,
            data: result.rows
        });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to fetch items'
        });
    }
});

app.post('/api/items', async (req, res) => {
    try {
        const { name, description } = req.body;

        if (!name) {
            return res.status(400).json({
                success: false,
                error: 'Name is required'
            });
        }

        const result = await pool.query(
            'INSERT INTO items (name, description) VALUES ($1, $2) RETURNING *',
            [name, description || '']
        );

        res.status(201).json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to create item'
        });
    }
});

app.delete('/api/items/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM items WHERE id = $1 RETURNING *', [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Item not found'
            });
        }

        res.json({
            success: true,
            message: 'Item deleted'
        });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete item'
        });
    }
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Route not found'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
});
