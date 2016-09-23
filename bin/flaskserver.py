from flask import Flask, request, send_from_directory
app = Flask(__name__, root_path='/opt/www')

@app.route('/<path:path>')
def send_static(path):
    return send_from_directory('', path)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=int("11180"), debug=True)
