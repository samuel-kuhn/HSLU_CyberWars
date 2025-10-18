<?php
header('Content-Type: application/json');
define('API_BASE', '/employees');

// --- Helper Functions ---

/**
 * Connecting to the SQLite database.
 * @return PDO
 */
function getDBConnection(): PDO {
    try {
        $pdo = new PDO('sqlite:data/employees.db');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        return $pdo;
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Internal server error: Database not available.']);
        exit;
    }
}

/**
 * Checks if the request is authenticated as the admin user (Harald Lustig).
 * @param string $email The submitted email.
 * @param string $password The submitted plain password.
 * @return bool True if authenticated, false otherwise.
 */
function authenticateUser(string $email, $password): bool {
    if ($email !== 'harald.lustig@company.com') {
        return false;
    }

    $pdo = getDBConnection();
    try {
        $stmt = $pdo->prepare("SELECT password_hash FROM employees WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            return false;
        }

        $hashed_password = md5($password);
        $storedHash = $user['password_hash'];

        return $hashed_password == $storedHash; 
        
    } catch (PDOException $e) {
        return false;
    }
}

// --- API Logic Functions (Using PDO PLACEHOLDERS) ---

/**
 * Lists all employees (excluding password hash).
 */
function listEmployees(): array {
    $pdo = getDBConnection();
    try {
        $stmt = $pdo->query("SELECT id, name, email, role FROM employees ORDER BY id DESC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        http_response_code(500);
        return ['error' => 'Failed to list employees.'];
    }
}

/**
 * Gets a specific employee by ID (excluding password hash).
 */
function getEmployee(string $id): array {
    $pdo = getDBConnection();
    try {
        $stmt = $pdo->prepare("SELECT * FROM employees WHERE id = ?");
        $stmt->execute([$id]);
        $employee = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$employee) {
            http_response_code(404); // Not Found
            return ['error' => "Employee with ID $id not found."];
        }
        return $employee;
    } catch (PDOException $e) {
        http_response_code(500);
        return ['error' => 'Failed to retrieve employee.'];
    }
}

/**
 * Deletes an employee by ID after authenticating the request.
 * @param string $id The employee ID to delete.
 * @param string $authEmail The email provided for authentication.
 * @param string $authPassword The password provided for authentication.
 * @return array Success or error message.
 */

// Note: Delete logic not yet implemented
function deleteEmployee(string $id, string $authEmail, $authPassword): array {
    if (!authenticateUser($authEmail, $authPassword)) {
        http_response_code(401); 
        return ['error' => 'Authentication failed.'];
    }

    $pdo = getDBConnection();
    try {
        $stmt = $pdo->prepare("SELECT * FROM employees WHERE id = ?");
        $stmt->execute([$id]);
        $employee = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$employee) {
            http_response_code(404); // Not Found
            return ['error' => "Employee with ID $id not found."];
        }

        return ['message' => "Employee with ID $id successfully deleted."];
    } catch (PDOException $e) {
        http_response_code(500);
        return ['error' => 'Failed to delete employee.'];
    }
}


/**
 * Creates a backup of the employee database.
 * @param string $backupPath (Optional) Path where the backup should be stored.
 * @param string $authEmail The email provided for authentication.
 * @param string $authPassword The password provided for authentication.
 * @return array Success or error message.
 */

// Note: Backup logic not yet implemented
function backupDatabase(string $backupPath, string $authEmail, $authPassword): array {
    if (!authenticateUser($authEmail, $authPassword)) {
        http_response_code(401); 
        return ['error' => 'Authentication failed.'];
    }

    $command = "/bin/sh backup-database.sh " . $backupPath;
    exec($command, $output, $return_var);

    if ($return_var !== 0) {
        http_response_code(500);
        return ['error' => "Backup script exited with code $return_var."];
    }

    return ['message' => "Backup script ran successfully with exit code $return_var."];
}

// --- API Router (Modified for /employees) ---

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (strpos($uri, API_BASE) === 0) {
    $path = substr($uri, strlen(API_BASE));
} else {
    $path = $uri;
}
$path = rtrim($path, '/');
$response = [];

switch ($path) {
    // GET /employees/list
    case '/list':
        if ($method === 'GET') {
            $response = listEmployees();
        } else {
            http_response_code(405);
            $response = ['error' => 'Method not supported for this endpoint.'];
        }
        break;

    // GET /employees/get?id=xzy
    case '/get':
        if ($method === 'GET') {
            $id = $_GET['id'] ?? null;
            if ($id) {
                $response = getEmployee($id);
            } else {
                http_response_code(400);
                $response = ['error' => 'Missing employee ID parameter.'];
            }
        } else {
            http_response_code(405);
            $response = ['error' => 'Method not supported for this endpoint.'];
        }
        break;

    // POST /employees/delete
    case '/delete':
        if ($method === 'POST') {
            $input = json_decode(file_get_contents('php://input'), true);
            
            $id = $input['idToDelete'] ?? null;
            $authEmail = $input['email'] ?? null;
            $authPassword = $input['password'] ?? null; 

            if ($id !== null && $authEmail !== null && $authPassword !== null) {
                $response = deleteEmployee($id, $authEmail, $authPassword); 
            } else {
                http_response_code(400); // Bad Request
                $response = ['error' => 'Missing data.'];
            }
        } else {
            http_response_code(405);
            $response = ['error' => 'Method not supported for this endpoint.'];
        }
        break;

    // POST /employees/backup
    case '/backup':
        if ($method === 'POST') {
            $input = json_decode(file_get_contents('php://input'), true);
            
            $backupPath = $input['backupPath'] ?? '/backups';
            $authEmail = $input['email'] ?? null; 
            $authPassword = $input['password'] ?? null; 

            if ($backupPath !== null && $authEmail !== null && $authPassword !== null) {
                $response = backupDatabase($backupPath, $authEmail, $authPassword); 
            } else {
                http_response_code(400); // Bad Request
                $response = ['error' => 'Missing data.'];
            }
        } else {
            http_response_code(405);
            $response = ['error' => 'Method not supported for this endpoint.'];
        }
        break;

    // 404 Not Found
    default:
        http_response_code(404);
        $response = ['error' => 'Endpoint not found.'];
        break;
}

echo json_encode($response);
exit;
