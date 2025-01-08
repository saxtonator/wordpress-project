# WordPress LEMP Stack Automation with MariaDB Backend

## Overview
INSERT OVERVIEW HERE
---

## Scripts

### 1. `lemp-setup.sh`
This script performs the following tasks:

#### **Core System Setup**
- Updates and upgrades the system packages.
- Logs the execution details for debugging and auditing.

#### **LEMP Stack Installation**
- Installs and configures:
  - Nginx as the web server.
  - PHP and its required extensions.
- Ensures Apache is disabled and stopped to avoid conflicts with Nginx.

#### **WordPress Deployment**
- Downloads and sets up WordPress in `/var/www/html`.
- Updates the `wp-config.php` file with:
  - Generated credentials (database name, username, password).
  - Security salts fetched dynamically.

#### **Cloudflare Integration**
- Creates an A record for the domain using the Cloudflare API.
- Ensures Nginx is configured for the specified domain and reloads the configuration.

#### **SSL Certificate Installation**
- Installs Certbot and configures SSL for the domain using the Certbot Nginx plugin.

### 2. `mariadb-setup.sh`
This script performs the following tasks:

#### **MariaDB Setup**
- Installs MariaDB server and client packages.
- Configures MariaDB to listen on all interfaces.
- Creates a new WordPress database, user, and grants privileges.

#### **Credential Management**
- Generates a random database username and password.
- Stores credentials securely in a local `creds.txt` file.
- Uploads `creds.txt` to an AWS S3 bucket.

#### **AWS Integration**
- Includes instructions for creating an IAM role for EC2 instances with S3 access.

---

## Prerequisites

1. **Ubuntu Server**
   - Recommended: Ubuntu 20.04 or later.

2. **Cloudflare Account**
   - Zone ID and API key for DNS management.

3. **AWS S3 Bucket**
   - For securely storing database credentials.

4. **Domain Name**
   - Pointed to the server's IP address.

5. **IAM Role (Optional)**
   - Attach to the EC2 instance for secure S3 access.

---

## Files and Directories

- **`lemp-setup.sh`**: Sets up the LEMP stack and deploys WordPress.
- **`mariadb-setup.sh`**: Configures MariaDB and manages database credentials.
- **`configs/`**: Contains additional configuration files (e.g., Nginx).

---

## Logs
Execution logs are saved to `/var/log/script_execution.log`.

---

## Future Improvements
- Implement enhanced error handling.
- Add support for additional hosting providers.
- Automate DNS configuration for other DNS providers.