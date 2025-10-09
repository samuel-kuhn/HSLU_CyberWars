from flask import Flask, request, jsonify
import os
from datetime import datetime
import json

app = Flask(__name__)

DEFAULT_REGISTRATION_DIR = '/var/www/html/registrations'

@app.route('/api/register', methods=['POST', 'GET'])
def register():
    if request.method == 'POST':
        data = request.get_json()
        if not data or 'name' not in data or 'email' not in data:
            return jsonify({'error': 'Missing data'}), 400
        
        # Use provided filepath or fallback to default
        registration_dir = data.get('filepath', DEFAULT_REGISTRATION_DIR)
        
        # Create the directory if it doesn't exist
        os.makedirs(registration_dir, exist_ok=True)
        
        # Create filename with username and timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        username = data['name'].replace(' ', '_').replace('/', '_')
        filename = f"{username}_{timestamp}.json"
        filepath = os.path.join(registration_dir, filename)
        
        # Save to file
        try:
            with open(filepath, 'w') as f:
                file_data = {k: v for k, v in data.items() if k != 'filepath'}
                json.dump(file_data, f, indent=2)
            return jsonify({'status': 'ok', 'file': filepath})
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    return jsonify({'message': 'Use POST to register'})

@app.route('/api/registrations', methods=['GET'])
def list_registrations():
    registration_dir = request.args.get('filepath', DEFAULT_REGISTRATION_DIR)
    
    if not os.path.exists(registration_dir):
        return jsonify({'error': f'Directory {registration_dir} does not exist'}), 404
    
    registrations = []
    
    try:
        # Read all files in the directory
        for filename in os.listdir(registration_dir):
            filepath = os.path.join(registration_dir, filename)
            
            # Only process files (not directories)
            if os.path.isfile(filepath):
                try:
                    # Try to read as JSON first
                    with open(filepath, 'r', encoding='utf-8') as f:
                        data = json.load(f)
                        data['filepath'] = filepath
                        registrations.append(data)
                except (json.JSONDecodeError, UnicodeDecodeError):
                    # If not JSON or not text, try to read as plain text
                    try:
                        with open(filepath, 'r', encoding='utf-8') as f:
                            content = f.read()
                            registrations.append({
                                'filepath': filepath,
                                'filename': filename,
                                'type': 'text'
                            })
                    except UnicodeDecodeError:
                        # Binary file - skip or show metadata only
                        registrations.append({
                            'filepath': filepath,
                            'filename': filename,
                            'type': 'binary',
                            'size': os.path.getsize(filepath)
                        })
        
        return jsonify(registrations)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Hidden endpoint to read a specific file (LFI vulnerability)
@app.route('/api/file', methods=['GET'])
def read_file():
    filepath = request.args.get('path', '')
    
    if not filepath:
        return jsonify({'error': 'No path specified'}), 400
    
    try:
        # Check if file exists
        if not os.path.exists(filepath):
            return jsonify({'error': 'File not found'}), 404
        
        if os.path.isdir(filepath):
            return jsonify({'error': 'Path is a directory, use /api/registrations instead'}), 400
        
        # Try to read as text
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                return jsonify({
                    'filepath': filepath,
                    'content': content,
                    'type': 'text'
                })
        except UnicodeDecodeError:
            # Binary file
            return jsonify({
                'filepath': filepath,
                'type': 'binary',
                'size': os.path.getsize(filepath),
                'error': 'Binary file - cannot display as text'
            })
    except PermissionError:
        return jsonify({'error': 'Permission denied'}), 403
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Debug endpoint with hints
@app.route('/api/debug', methods=['GET'])
def debug():
    return jsonify({
        'endpoints': [
            '/api/register',
            '/api/registrations',
            '/api/file',
            '/api/debug'
        ],
        'parameters': {
            '/api/registrations': ['filepath'],
            '/api/file': ['path']
        },
        'hint': 'Try exploring the filesystem with the filepath parameter',
        'example': '/api/file?path=/etc/passwd'
    })

