const request = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');

describe('API Caki Backend', () => {
  let server;
  beforeAll((done) => {
    server = app.listen(4000, () => done());
  });
  afterAll((done) => {
    mongoose.connection.close();
    server.close(done);
  });

  let token;

  test('Deve registrar um usuário', async () => {
    const res = await request(server)
      .post('/auth/register')
      .send({ username: 'testuser', password: 'testpass' });
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toBeDefined();
  });

  test('Deve fazer login e retornar token', async () => {
    const res = await request(server)
      .post('/auth/login')
      .send({ username: 'testuser', password: 'testpass' });
    expect(res.statusCode).toBe(200);
    expect(res.body.token).toBeDefined();
    token = res.body.token;
  });

  test('Deve acessar rota protegida /rooms', async () => {
    const res = await request(server)
      .get('/rooms')
      .set('Authorization', 'Bearer ' + token);
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  test('Não deve acessar rota protegida /rooms sem token', async () => {
    const res = await request(server)
      .get('/rooms');
    expect(res.statusCode).toBe(401);
    expect(res.body.error).toBeDefined();
  });
});
