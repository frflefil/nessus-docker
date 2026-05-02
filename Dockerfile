FROM ubuntu:22.04

LABEL maintainer="docker-builder" \
      description="OpenVAS-like Vulnerability Scanner Web Interface" \
      version="2.0"

RUN apt-get update && apt-get install -y python3 python3-flask curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/scanner /var/lib/scanner /var/log/scanner

WORKDIR /app

RUN cat > app.py << 'PYEOF'
from flask import Flask, render_template_string
app = Flask(__name__)

@app.route('/')
def dashboard():
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>OpenVAS Dashboard</title>
        <style>
            body { font-family: Arial; background: #f5f5f5; margin: 0; }
            .container { max-width: 1200px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; }
            h1 { color: #00a84f; }
            .status { display: flex; gap: 20px; }
            .box { background: #f9f9f9; padding: 20px; border-left: 4px solid #00a84f; }
            button { background: #00a84f; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>OpenVAS 23.04 - Vulnerability Scanner</h1>
            <p>Status: <strong>Online</strong> ✓</p>
            
            <div class="status">
                <div class="box">
                    <h3>Escaneos</h3>
                    <p>Total: 0</p>
                    <button onclick="alert('Demo Mode')">Nuevo Escaneo</button>
                </div>
                <div class="box">
                    <h3>Tareas</h3>
                    <p>Activas: 0</p>
                    <button onclick="alert('Demo Mode')">Ver Tareas</button>
                </div>
                <div class="box">
                    <h3>Reportes</h3>
                    <p>Total: 0</p>
                    <button onclick="alert('Demo Mode')">Generar Reporte</button>
                </div>
            </div>
            
            <hr>
            <h3>Información del Sistema</h3>
            <ul>
                <li>Versión: OpenVAS 23.04</li>
                <li>Base de Datos: /var/lib/scanner</li>
                <li>Configuración: /etc/scanner</li>
                <li>Logs: /var/log/scanner</li>
            </ul>
            <p><small>Demo Mode - Docker Deployment</small></p>
        </div>
    </body>
    </html>
    """
    return render_template_string(html)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
PYEOF

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

CMD ["python3", "/app/app.py"]
