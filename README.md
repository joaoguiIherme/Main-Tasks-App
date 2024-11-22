---

# Main Tasks App

Main Tasks App is a multi-service application designed for task management and notifications. It leverages microservices architecture with services running on Docker containers, including an authentication service, notifications service, scraping service, and a PostgreSQL database.

This README provides an overview of the project, its setup, and instructions for running the application.

---

## Features

- **User Authentication**: Registration, login, and secure token-based authentication with JWT.
- **Task Management**: Create, update, and manage tasks via the main application.
- **Notifications Service**: Handles notifications related to task status updates.
- **Scraping Service**: Processes scraping tasks and communicates updates to other services.
- **Dockerized Microservices**: Each service is isolated in its container for ease of development and deployment.

---

## Architecture

The application is structured into the following services:

1. **Main App**:
   - Serves as the main interface for users.
   - Manages tasks and communicates with other services.
   - Exposed on port `3000`.

2. **Authentication Service**:
   - Handles user registration, login, and token validation.
   - Exposed on port `4000`.

3. **Notifications Service**:
   - Manages notifications for task updates.
   - Exposed on port `4001`.

4. **Scraping Service**:
   - Handles scraping tasks and updates task statuses.
   - Exposed on port `4002`.

5. **Database**:
   - PostgreSQL instance shared by all services.

---

## Prerequisites

Ensure you have the following installed:

- [Docker](https://www.docker.com/get-started) (Version 20.10 or higher)
- [Docker Compose](https://docs.docker.com/compose/) (Version 2.x or higher)
- [auth_service](https://github.com/joaoguiIherme/auth_service)
- [notifications_service](https://github.com/joaoguiIherme/notifications_service)
- [scraping_service](https://github.com/joaoguiIherme/scraping_service)
---

## Installation

### File Structure Adjustment

Before proceeding, ensure the `docker-compose.yml` file is relocated as shown below:

```plaintext
Main-Root Dir/
├── auth_service/
├── main_app/ (this github repo)
├── notifications_service/
├── scraping_service/
└── docker-compose.yml
```

Move the `docker-compose.yml` file from the `main_app` directory to the root directory of the project.

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/joaoguiIherme/main_app.git
   ```

2. Ensure the `docker-compose.yml` file is in the root directory as described above.

3. Build and start the services using Docker Compose:
   ```bash
   docker-compose up --build
   ```

4. Access the services in your browser:
   - **Main App**: [http://localhost:3000](http://localhost:3000)
   - **Authentication Service**: [http://localhost:4000](http://localhost:4000)
   - **Notifications Service**: [http://localhost:4001](http://localhost:4001)
   - **Scraping Service**: [http://localhost:4002](http://localhost:4002)

---

## Configuration

### Environment Variables

Each service uses environment variables defined in the `docker-compose.yml` file:

- **Main App**:
  - `DATABASE_URL`: Connection string for the PostgreSQL database.
  - `RAILS_ENV`: Set to `development`.

- **Authentication Service**:
  - `DATABASE_URL`: Connection string for the PostgreSQL database.

- **Notifications Service**:
  - `DATABASE_URL`: Connection string for the PostgreSQL database.

- **Scraping Service**:
  - `DATABASE_URL`: Connection string for the PostgreSQL database.

### Network Configuration

All services communicate using the Docker network `app_network`. Ensure that service names in the code (e.g., `auth_service`, `notifications_service`) match the names defined in `docker-compose.yml`.

---

## Usage

### User Authentication

1. Navigate to the main app at [http://localhost:3000/login](http://localhost:3000/login).
2. Register a new user or log in with an existing account.

### Task Management

1. Create, view, and manage tasks from the main app interface.
2. Notifications and updates will be handled by the notifications service.

### Debugging Services

To check if a service is running, use:
```bash
docker ps
```

To inspect logs for a specific service, use:
```bash
docker logs <service_name>
```

Example:
```bash
docker logs main_app
```

---

## Testing

Run tests for each service as follows:

1. Access the container for the service:
   ```bash
   docker exec -it <service_name> bash
   ```

2. Run Rails tests:
   ```bash
   bundle exec rspec
   ```

---

## Troubleshooting

### Common Errors

- **Database Connection Issues**:
  Ensure the `db` service is running, and the `DATABASE_URL` environment variable is correctly set.

- **Host Authorization Error**:
  Add the service hostnames to `config.hosts` in the respective Rails apps.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit changes and push to your fork.
4. Submit a pull request.

---

## Acknowledgments

This application was inspired by the microservices architecture and leverages the flexibility of Docker and Rails to provide a scalable and maintainable solution for task management.

---
