<?php

header('Content-Type: application/json');
define('API_BASE', '/employees');

// --- Helper Functions ---


/**
 * Placeholder for connecting to the SQLite database.
 * In a real application, this would be a class or connection service.
 * @return PDO
 */
function getDBConnection(): PDO {
    // Note: This connects to the database file.
    // Ensure the file 'employees.db' exists and is writable by the web server.
    try {
        $pdo = new PDO('sqlite:employees.db');
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        //$pdo->setAttribute(PDO::ATTR_STRINGIFY_FETCHES, true); 
        
        return $pdo;
    } catch (PDOException $e) {
        // Log the error and fail gracefully
        error_log("Database connection failed: " . $e->getMessage());
        http_response_code(500);
        echo json_encode(['error' => 'Internal server error: Database not available.']);
        exit;
    }
}

/**
 * Checks if the request is authenticated by the admin user (Harald Lustig).
 * @param string $email The submitted email.
 * @param string $password The submitted plain password.
 * @return bool True if authenticated, false otherwise.
 */
function authenticateUser(string $email, $password): bool {
    // Only target the admin user for the challenge
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

        $storedHash = $user['password_hash'];

        return $password == $storedHash; 
        
    } catch (PDOException $e) {
        error_log("Authentication DB Error: " . $e->getMessage());
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
        error_log("Error listing employees: " . $e->getMessage());
        return ['error' => 'Failed to list employees.'];
    }
}

/**
 * Gets a specific employee by ID (excluding password hash).
 */
function getEmployee(string $id): array {
    $pdo = getDBConnection();
    try {
        $stmt = $pdo->prepare("SELECT id, name, email, role FROM employees WHERE id = ?");
        $stmt->execute([$id]);
        $employee = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$employee) {
            http_response_code(404); // Not Found
            return ['error' => "Employee with ID $id not found."];
        }
        return $employee;
    } catch (PDOException $e) {
        http_response_code(500);
        error_log("Error getting employee: " . $e->getMessage());
        return ['error' => 'Failed to retrieve employee.'];
    }
}

/**
 * Deletes an employee by ID after authenticating the request.
 * @param string $id The employee ID to delete.
 * @param string $authEmail The email provided for authentication.
 * @param $authPassword The password provided for authentication.
 * @return array Success or error message.
 */

// Note: password has no explicit type so php will cast it to integer.
function deleteEmployee(string $id, string $authEmail, $authPassword): array {
    // --- 1. Authentication Check ---
    if (!authenticateUser($authEmail, $authPassword)) {
        http_response_code(401); 
        return ['error' => 'Authentication failed.'];
    }

    $pdo = getDBConnection();
    try {
        $stmt = $pdo->prepare("DELETE FROM employees WHERE id = ?");
        $stmt->execute([$id]);

        if ($stmt->rowCount() === 0) {
            http_response_code(404); // Not Found
            return ['error' => "Employee with ID $id not found for deletion."];
        }

        return ['message' => "Employee with ID $id successfully deleted."];
    } catch (PDOException $e) {
        http_response_code(500);
        error_log("Error deleting employee: " . $e->getMessage());
        return ['error' => 'Failed to delete employee.'];
    }
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
            
            // Extract required fields
            $id = $input['idToDelete'] ?? null;
            $authEmail = $input['email'] ?? null;
            
            // Crucial: The password must **not** be cast to string before being passed 
            $authPassword = $input['password'] ?? ''; 

            if ($id !== null && $authEmail !== null && $authPassword !== '') {
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

    // 404 Not Found
    default:
        http_response_code(404);
        $response = ['error' => 'Endpoint not found.'];
        break;
}

echo json_encode($response);
exit;