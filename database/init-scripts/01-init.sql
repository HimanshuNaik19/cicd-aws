-- Create items table
CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on created_at for faster queries
CREATE INDEX idx_items_created_at ON items(created_at DESC);

-- Insert sample data
INSERT INTO items (name, description) VALUES
    ('Docker', 'Containerization platform for building and deploying applications'),
    ('Kubernetes', 'Container orchestration platform for automating deployment, scaling, and management'),
    ('Terraform', 'Infrastructure as Code tool for provisioning cloud resources'),
    ('Jenkins', 'Automation server for building CI/CD pipelines');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_items_updated_at BEFORE UPDATE
    ON items FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant permissions
GRANT ALL PRIVILEGES ON TABLE items TO devops_user;
GRANT USAGE, SELECT ON SEQUENCE items_id_seq TO devops_user;
