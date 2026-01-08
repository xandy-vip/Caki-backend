const axios = require('axios');
const baseURL = 'http://localhost:3000';

async function testAuthFlow() {
  try {
    // 1. Registrar usuário
    const registerRes = await axios.post(baseURL + '/auth/register', {
      username: 'testuser',
      password: 'testpass'
    });
    console.log('Registro:', registerRes.data);

    // 2. Login
    const loginRes = await axios.post(baseURL + '/auth/login', {
      username: 'testuser',
      password: 'testpass'
    });
    console.log('Login:', loginRes.data);
    const token = loginRes.data.token;

    // 3. Acessar rota protegida (listar salas)
    const roomsRes = await axios.get(baseURL + '/rooms', {
      headers: { Authorization: 'Bearer ' + token }
    });
    console.log('Salas:', roomsRes.data);

    // 4. Tentar acessar rota protegida sem token
    try {
      await axios.get(baseURL + '/rooms');
    } catch (err) {
      console.log('Sem token:', err.response.data);
    }
  } catch (err) {
    console.error('Erro no teste:', err.response?.data || err.message);
  }
}

testAuthFlow();
