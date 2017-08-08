'use strict';

const fs = require('fs');
const path = require('path')
const { mapValues, has } = require('lodash');

module.exports = function requireSQL(...args) {
  const filename = path.join(...args);
  const lines = fs.readFileSync(filename, 'utf8').split('\n');
  let currentQuery;
  return mapValues(
    lines.reduce((accum, line) => {
      if (line.startsWith('--@')) {
        currentQuery = line.slice(3).trim();
      } else {
        if (!has(accum, currentQuery)) {
          accum[currentQuery] = [line];
        } else {
          accum[currentQuery].push(line);
        }
      }
      return accum;
    }, {}),
    val => val.join('\n')
  );
};
