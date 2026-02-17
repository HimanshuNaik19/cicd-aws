import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

function App() {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [newItem, setNewItem] = useState({ name: '', description: '' });

    useEffect(() => {
        fetchItems();
    }, []);

    const fetchItems = async () => {
        try {
            setLoading(true);
            const response = await axios.get(`${API_URL}/api/items`);
            setItems(response.data.data || []);
            setError(null);
        } catch (err) {
            setError('Failed to fetch items');
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!newItem.name.trim()) return;

        try {
            await axios.post(`${API_URL}/api/items`, newItem);
            setNewItem({ name: '', description: '' });
            fetchItems();
        } catch (err) {
            setError('Failed to create item');
            console.error(err);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Delete this item?')) return;

        try {
            await axios.delete(`${API_URL}/api/items/${id}`);
            fetchItems();
        } catch (err) {
            setError('Failed to delete item');
            console.error(err);
        }
    };

    return (
        <div className="App">
            <header className="header">
                <h1>🚀 DevOps Application</h1>
                <p>Simple Full-Stack Demo</p>
            </header>

            <main className="container">
                {error && (
                    <div className="alert error">
                        {error}
                        <button onClick={() => setError(null)}>✕</button>
                    </div>
                )}

                <div className="form-section">
                    <h2>Add New Item</h2>
                    <form onSubmit={handleSubmit}>
                        <input
                            type="text"
                            placeholder="Item name"
                            value={newItem.name}
                            onChange={(e) => setNewItem({ ...newItem, name: e.target.value })}
                            required
                        />
                        <textarea
                            placeholder="Description (optional)"
                            value={newItem.description}
                            onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}
                            rows="3"
                        />
                        <button type="submit" className="btn-primary">Add Item</button>
                    </form>
                </div>

                <div className="items-section">
                    <h2>Items ({items.length})</h2>
                    {loading ? (
                        <div className="loading">Loading...</div>
                    ) : items.length === 0 ? (
                        <div className="empty">No items yet. Add one above!</div>
                    ) : (
                        <div className="items-grid">
                            {items.map((item) => (
                                <div key={item.id} className="item-card">
                                    <h3>{item.name}</h3>
                                    {item.description && <p>{item.description}</p>}
                                    <small>{new Date(item.created_at).toLocaleDateString()}</small>
                                    <button onClick={() => handleDelete(item.id)} className="btn-delete">
                                        Delete
                                    </button>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </main>

            <footer className="footer">
                <p>Built with React + Node.js + PostgreSQL</p>
            </footer>
        </div>
    );
}

export default App;
