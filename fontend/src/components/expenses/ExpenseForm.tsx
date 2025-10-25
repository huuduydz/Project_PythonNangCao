import React, { useState } from 'react';
import { categories, Group, User } from '../../data/mockData';

interface ExpenseFormProps {
  group: Group;
  onSubmit: (expense: any) => void;
  onCancel: () => void;
}

export default function ExpenseForm({ group, onSubmit, onCancel }: ExpenseFormProps) {
  const [description, setDescription] = useState('');
  const [amount, setAmount] = useState('');
  const [category, setCategory] = useState(categories[0].id);
  const [paidBy, setPaidBy] = useState(group.members[0].id);
  const [splitType, setSplitType] = useState<'equal' | 'custom'>('equal');
  const [customSplits, setCustomSplits] = useState<Record<string, number>>({});
  const [receipt, setReceipt] = useState<File | null>(null);
  const [isRecurring, setIsRecurring] = useState(false);
  const [recurringFrequency, setRecurringFrequency] = useState<'weekly' | 'monthly'>('monthly');

  // Initialize custom splits with equal amounts
  React.useEffect(() => {
    if (amount) {
      const equalShare = parseFloat(amount) / group.members.length;
      const splits = Object.fromEntries(
        group.members.map(m => [m.id, equalShare])
      );
      setCustomSplits(splits);
    }
  }, [amount, group.members]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    const splits = splitType === 'equal' 
      ? group.members.map(m => ({
          userId: m.id,
          amount: parseFloat(amount) / group.members.length
        }))
      : Object.entries(customSplits).map(([userId, amount]) => ({
          userId,
          amount
        }));

    const expenseData = {
      description,
      amount: parseFloat(amount),
      category,
      paidBy,
      groupId: group.id,
      date: new Date().toISOString(),
      split: splits,
      recurring: isRecurring ? {
        frequency: recurringFrequency,
        nextDate: new Date() // You'd calculate this based on frequency
      } : null
    };

    onSubmit(expenseData);
  };

  const handleSplitChange = (userId: string, value: string) => {
    setCustomSplits(prev => ({
      ...prev,
      [userId]: parseFloat(value) || 0
    }));
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files?.[0]) {
      setReceipt(e.target.files[0]);
    }
  };

  const totalCustomSplit = Object.values(customSplits).reduce((sum, val) => sum + val, 0);
  const splitError = Math.abs(totalCustomSplit - parseFloat(amount || '0')) > 0.01;

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div>
        <label className="block text-sm font-medium text-gray-700">Description</label>
        <input
          type="text"
          required
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Amount ({group.currency})</label>
        <input
          type="number"
          required
          min="0"
          step="0.01"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Category</label>
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        >
          {categories.map((cat) => (
            <option key={cat.id} value={cat.id}>
              {cat.icon} {cat.name}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Paid by</label>
        <select
          value={paidBy}
          onChange={(e) => setPaidBy(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        >
          {group.members.map((member) => (
            <option key={member.id} value={member.id}>
              {member.name}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Split Type</label>
        <select
          value={splitType}
          onChange={(e) => setSplitType(e.target.value as 'equal' | 'custom')}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        >
          <option value="equal">Split Equally</option>
          <option value="custom">Custom Split</option>
        </select>
      </div>

      {splitType === 'custom' && (
        <div className="space-y-4">
          <p className="text-sm font-medium text-gray-700">Custom Split</p>
          {group.members.map((member) => (
            <div key={member.id} className="flex items-center space-x-4">
              <span className="w-32 text-sm">{member.name}</span>
              <input
                type="number"
                min="0"
                step="0.01"
                value={customSplits[member.id] || ''}
                onChange={(e) => handleSplitChange(member.id, e.target.value)}
                className="block w-24 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
              />
            </div>
          ))}
          {splitError && (
            <p className="text-sm text-red-600">
              Total split amount must equal expense amount
            </p>
          )}
        </div>
      )}

      <div>
        <label className="block text-sm font-medium text-gray-700">Receipt (Optional)</label>
        <input
          type="file"
          accept="image/*"
          onChange={handleFileChange}
          className="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
        />
      </div>

      <div className="flex items-center">
        <input
          type="checkbox"
          id="recurring"
          checked={isRecurring}
          onChange={(e) => setIsRecurring(e.target.checked)}
          className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
        />
        <label htmlFor="recurring" className="ml-2 block text-sm text-gray-700">
          Recurring expense
        </label>
      </div>

      {isRecurring && (
        <div>
          <label className="block text-sm font-medium text-gray-700">Frequency</label>
          <select
            value={recurringFrequency}
            onChange={(e) => setRecurringFrequency(e.target.value as 'weekly' | 'monthly')}
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          >
            <option value="weekly">Weekly</option>
            <option value="monthly">Monthly</option>
          </select>
        </div>
      )}

      <div className="flex justify-end space-x-3">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={splitType === 'custom' && splitError}
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-gray-400"
        >
          Add Expense
        </button>
      </div>
    </form>
  );
}