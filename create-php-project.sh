#!/bin/bash

read -p "Enter project name: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo "Project name is required"
    exit 1
fi

mkdir -p "$PROJECT_NAME/src"
cd "$PROJECT_NAME"

cat > docker-compose.yml << 'EOF'
services:
  php:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./src:/var/www/html
    depends_on:
      db:
        condition: service_healthy

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: app
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 5s
      timeout: 5s
      retries: 10
EOF

cat > Dockerfile << 'EOF'
FROM php:8.3-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql
EOF

cat > init.sql << 'EOF'
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
INSERT INTO users (name) VALUES ('Michael Barley');
EOF

cat > src/index.php << 'EOF'
<?php
$conn = new mysqli('db', 'root', 'root', 'app');
$result = $conn->query("SELECT name FROM users LIMIT 1");
$user = $result->fetch_assoc();
?>
<!DOCTYPE html>
<html>
<head>
    <title>PHP Dev</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card {
            background: white;
            padding: 3rem 4rem;
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            text-align: center;
        }
        h1 {
            font-size: 2rem;
            color: #1a202c;
            font-weight: 300;
        }
        span { font-weight: 600; color: #667eea; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Happy coding, <span><?= htmlspecialchars($user['name']) ?></span> :)</h1>
    </div>
</body>
</html>
EOF

docker compose up -d --build

echo ""
echo "Ready at http://localhost:8080"
