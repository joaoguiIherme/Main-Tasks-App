import React, { useState, useEffect } from "react";

const TaskList = () => {
  const [tasks, setTasks] = useState([]);
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    task_type: "generic",
  });

  useEffect(() => {
    fetch("/tasks")
      .then((response) => response.json())
      .then((data) => setTasks(data));
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    fetch("/tasks", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    })
      .then((response) => response.json())
      .then((newTask) => setTasks([newTask, ...tasks]));
  };

  const handleDelete = (id) => {
    fetch(`/tasks/${id}`, { method: "DELETE" }).then(() => {
      setTasks(tasks.filter((task) => task.id !== id));
    });
  };

  return (
    <div>
      <h1>Tasks</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Title"
          value={formData.title}
          onChange={(e) => setFormData({ ...formData, title: e.target.value })}
        />
        <textarea
          placeholder="Description"
          value={formData.description}
          onChange={(e) =>
            setFormData({ ...formData, description: e.target.value })
          }
        ></textarea>
        <select
          value={formData.task_type}
          onChange={(e) =>
            setFormData({ ...formData, task_type: e.target.value })
          }
        >
          <option value="generic">Generic</option>
          <option value="web_scraping">Web Scraping</option>
        </select>
        <button type="submit">Create Task</button>
      </form>

      <ul>
        {tasks.map((task) => (
          <li key={task.id}>
            {task.title} - {task.task_type}
            <button onClick={() => handleDelete(task.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default TaskList;
