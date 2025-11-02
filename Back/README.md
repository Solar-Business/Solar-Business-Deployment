# Solar Backend (Node.js)

Rápido backend para pruebas usando SQLite.

Instalación:
1. cd BACK
2. npm install
3. cp .env.example .env  && editar .env si quieres
4. npm run seed   # crea usuarios de ejemplo
5. npm run dev    # o npm start

API principales:
- POST /api/auth/register
- POST /api/auth/login
- GET /api/users
- GET /api/users/:id
- POST /api/users
- PUT /api/users/:id
- DELETE /api/users/:id

Login devuelve: { token, user: { id, name, email, role } }
Token en Authorization: Bearer <token>


Probar login con curl:
curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"support@example.com","password":"supportpass"}'

Respuesta: { token, user: {...} }

Probar CRUD (usar token obtenido):
curl -H "Authorization: Bearer <token>" http://localhost:3000/api/users