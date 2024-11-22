// app/javascript/components/TaskBoard.jsx
import React from 'react';

const TaskBoard = ({ tasks }) => {
  const groupedTasks = tasks.reduce((groups, task) => {
    if (!groups[task.status]) {
      groups[task.status] = [];
    }
    groups[task.status].push(task);
    return groups;
  }, {});

  return (
    <div className="task-board">
      {Object.keys(groupedTasks).map((status) => (
        <div key={status} className="task-column">
          <h3>{status}</h3>
          <ul>
            {groupedTasks[status].map((task) => (
              <li key={task.id}>{task.title}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
};

export default TaskBoard;
