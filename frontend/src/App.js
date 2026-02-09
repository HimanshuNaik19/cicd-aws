import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

function App() {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [newItem, setNewItem] = useState({ name: '', description: '' });
    const [editingId, setEditingId] = useState(null);

    // Fetch items on component mount
    useEffect(() => {
        fetchItems();
    }, []);

    const fetchItems = async () => {
        try {
            setLoading(true);
            const response = await axios.get(`${API_URL}/items`);
            setItems(response.data.data || []);
            setError(null);
        } catch (err) {
            setError('Failed to fetch items. Please check if the backend is running.');
            console.error('Error fetching items:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!newItem.name.trim()) return;

        try {
            if (editingId) {
                await axios.put(`${API_URL}/items/${editingId}`, newItem);
                setEditingId(null);
            } else {
                await axios.post(`${API_URL}/items`, newItem);
            }
            setNewItem({ name: '', description: '' });
            fetchItems();
        } catch (err) {
            setError('Failed to save item');
            console.error('Error saving item:', err);
        }
    };

    const handleEdit = (item) => {
        setNewItem({ name: item.name, description: item.description });
        setEditingId(item.id);
    };

    const handleDelete = async (id) => {
        if (!window.confirm('Are you sure you want to delete this item?')) return;

        try {
            await axios.delete(`${API_URL}/items/${id}`);
            fetchItems();
        } catch (err) {
            setError('Failed to delete item');
            console.error('Error deleting item:', err);
        }
    };

    const handleCancel = () => {
        setNewItem({ name: '', description: '' });
        setEditingId(null);
    };

    return (
        <div className="App">
            <header className="App-header">
                <h1>🚀 Multi-Tier DevOps Application</h1>
                <p className="subtitle">Docker • Kubernetes • Terraform • Jenkins</p>
            </header>

            <main className="container">
                {error && (
                    <div className="alert alert-error">
                        {error}
                        <button onClick={() => setError(null)}>✕</button>
                    </div>
                )}

                <div className="form-section">
                    <h2>{editingId ? 'Edit Item' : 'Add New Item'}</h2>
                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <input
                                type="text"
                                placeholder="Item name"
                                value={newItem.name}
                                onChange={(e) => setNewItem({ ...newItem, name: e.target.value })}
                                required
                            />
                        </div>
                        <div className="form-group">
                            <textarea
                                placeholder="Description (optional)"
                                value={newItem.description}
                                onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}
                                rows="3"
                            />
                        </div>
                        <div className="button-group">
                            <button type="submit" className="btn btn-primary">
                                {editingId ? 'Update' : 'Add'} Item
                            </button>
                            {editingId && (
                                <button type="button" className="btn btn-secondary" onClick={handleCancel}>
                                    Cancel
                                </button>
                            )}
                        </div>
                    </form>
                </div>

                <div className="items-section">
                    <h2>Items List</h2>
                    {loading ? (
                        <div className="loading">Loading...</div>
                    ) : items.length === 0 ? (
                        <div className="empty-state">
                            <p>No items yet. Add your first item above!</p>
                        </div>
                    ) : (
                        <div className="items-grid">
                            {items.map((item) => (
                                <div key={item.id} className="item-card">
                                    <h3>{item.name}</h3>
                                    {item.description && <p>{item.description}</p>}
                                    <div className="item-meta">
                                        <small>Created: {new Date(item.created_at).toLocaleDateString()}</small>
                                    </div>
                                    <div className="item-actions">
                                        <button onClick={() => handleEdit(item)} className="btn btn-sm btn-edit">
                                            Edit
                                        </button>
                                        <button onClick={() => handleDelete(item.id)} className="btn btn-sm btn-delete">
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </main>

            <footer className="App-footer">
                <p>Built with ❤️ for DevOps Portfolio</p>
            </footer>
        </div>
    );
}

export default App;
