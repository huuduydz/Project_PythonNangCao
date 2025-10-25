import React from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/layout/Header';
import GroupList from './components/groups/GroupList';

// Import pages
const Dashboard = () => (
  <div className="p-6">
    <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div className="card">
        <h2 className="text-xl font-semibold mb-2">Total Balance</h2>
        <p className="text-3xl font-bold text-blue-600">$0.00</p>
      </div>
      <div className="card">
        <h2 className="text-xl font-semibold mb-2">You Owe</h2>
        <p className="text-3xl font-bold text-red-600">$0.00</p>
      </div>
      <div className="card">
        <h2 className="text-xl font-semibold mb-2">You are Owed</h2>
        <p className="text-3xl font-bold text-green-600">$0.00</p>
      </div>
    </div>
  </div>
);

const Groups = () => (
  <div className="p-6">
    <div className="flex justify-between items-center mb-6">
      <h1 className="text-2xl font-bold">Groups</h1>
      <button className="btn-primary">Create New Group</button>
    </div>
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div className="card">
        <h2 className="text-xl font-semibold mb-2">Trip to Paris</h2>
        <p className="text-gray-600 mb-4">4 members</p>
        <div className="flex justify-between items-center">
          <span className="text-sm text-gray-500">Total: $1,200.00</span>
          <button className="btn-secondary">View Details</button>
        </div>
      </div>
      {/* Add more group cards here */}
    </div>
  </div>
);

const Expenses = () => (
  <div className="p-6">
    <div className="flex justify-between items-center mb-6">
      <h1 className="text-2xl font-bold">Expenses</h1>
      <button className="btn-primary">Add New Expense</button>
    </div>
    <div className="space-y-4">
      <div className="card">
        <div className="flex justify-between items-center">
          <div>
            <h3 className="text-lg font-semibold">Dinner at Restaurant</h3>
            <p className="text-gray-600">Paid by John</p>
          </div>
          <div className="text-right">
            <p className="text-xl font-bold">$120.00</p>
            <p className="text-sm text-gray-500">Your share: $30.00</p>
          </div>
        </div>
      </div>
      {/* Add more expense cards here */}
    </div>
  </div>
);

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        <Header />
        <main className="container mx-auto px-4">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/groups" element={<GroupList />} />
            <Route path="/expenses" element={<Expenses />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;