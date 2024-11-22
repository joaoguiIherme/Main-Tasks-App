import React from 'react';
import ReactDOM from 'react-dom';
import TaskBoard from './components/TaskBoard';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('react-task-board');
  if (node) {
    const tasks = JSON.parse(node.getAttribute('data-tasks'));
    ReactDOM.render(<TaskBoard tasks={tasks} />, node);
  }
});
