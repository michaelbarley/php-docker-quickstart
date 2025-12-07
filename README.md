# PHP Docker Environment

A minimal script that creates a complete PHP development environment using Docker. No local PHP or MySQL installation required.

## Requirements

- Docker Desktop

## Usage

```bash
./create-php-project.sh
```

Enter a project name when prompted. The script will create a new directory with that name and start the containers.

Once complete, open http://localhost:8080 in your browser.

## What Gets Created

- `docker-compose.yml` - container configuration
- `Dockerfile` - PHP image setup
- `init.sql` - database seed with users table
- `src/index.php` - entry point for your app

## Stack

- PHP 8.3 with Apache
- MySQL 8.0

## Development

Edit files in the `src/` directory. Changes appear immediately on refresh.

## Database Access

From PHP, connect using:

- Host: `db`
- User: `root`
- Password: `root`
- Database: `app`

## Commands

Stop the environment:

```bash
docker compose down
```

Start it again:

```bash
docker compose up -d
```

View logs:

```bash
docker compose logs -f
```
