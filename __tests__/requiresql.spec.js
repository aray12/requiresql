'use strict';

const requireSQL = require('../index.js');

describe('requiresql', () => {
  it('should load the sql into JS objects', () => {
    const queries = requireSQL(__dirname, '/queries.sql');

    expect(queries).toMatchSnapshot();
  })
})
