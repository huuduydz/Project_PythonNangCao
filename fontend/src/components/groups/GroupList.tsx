import React, { useState, useEffect } from 'react';
import { mockGroups, mockUsers, Group, mockExpenses, calculateGroupTotal, calculateUserBalance } from '../../data/mockData';
import { PlusIcon, UserGroupIcon, CurrencyDollarIcon, CalendarIcon } from '@heroicons/react/24/outline';

export default function GroupList() {
  const [myGroups, setMyGroups] = useState<Group[]>([]);
  const [showCreateModal, setShowCreateModal] = useState(false);

  useEffect(() => {
    // In real app, fetch user's groups from API
    setMyGroups(mockGroups);
  }, []);

  // Format currency based on the group's currency
  const formatCurrency = (amount: number, currency: string) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: currency
    }).format(amount);
  };

  return (
    <div className="px-4 sm:px-6 lg:px-8">
      <div className="sm:flex sm:items-center">
        <div className="sm:flex-auto">
          <h1 className="text-2xl font-semibold text-gray-900">Nhóm của tôi</h1>
          <p className="mt-2 text-sm text-gray-700">
            Danh sách các nhóm bạn đang tham gia và quản lý chi tiêu chung.
          </p>
        </div>
        <div className="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
          <button
            type="button"
            onClick={() => setShowCreateModal(true)}
            className="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:w-auto"
          >
            <PlusIcon className="-ml-1 mr-2 h-5 w-5" />
            Tạo nhóm mới
          </button>
        </div>
      </div>

      <div className="mt-8 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {myGroups.map((group) => (
          <div
            key={group.id}
            className="relative rounded-lg border border-gray-300 bg-white px-6 py-5 shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <UserGroupIcon className="h-10 w-10 text-gray-400" />
              </div>
              <div className="min-w-0 flex-1">
                <a href={`/groups/${group.id}`} className="focus:outline-none">
                  <p className="text-lg font-medium text-gray-900">{group.name}</p>
                  <p className="text-sm text-gray-500">{group.members.length} thành viên</p>
                </a>
              </div>
            </div>
            
            <div className="mt-4 border-t border-gray-200 pt-4">
              <div className="flex items-center justify-between text-sm text-gray-500">
                <div className="flex items-center">
                  <CurrencyDollarIcon className="h-5 w-5 mr-1" />
                  <span>Tổng chi tiêu:</span>
                </div>
                <span className="font-medium">
                  {formatCurrency(calculateGroupTotal(group.id), group.currency)}
                </span>
              </div>
              
              <div className="mt-2 flex items-center justify-between text-sm text-gray-500">
                <div className="flex items-center">
                  <CalendarIcon className="h-5 w-5 mr-1" />
                  <span>Ngày tạo:</span>
                </div>
                <span>
                  {new Date(group.createdAt).toLocaleDateString('vi-VN')}
                </span>
              </div>
            </div>

            <div className="mt-4">
              <div className="flex -space-x-2 overflow-hidden justify-end">
                {group.members.map((member) => (
                  <img
                    key={member.id}
                    className="inline-block h-8 w-8 rounded-full ring-2 ring-white"
                    src={member.avatar}
                    alt={member.name}
                  />
                ))}
              </div>
            </div>

            {group.notes && (
              <div className="mt-4 text-sm text-gray-500">
                <p className="italic">{group.notes}</p>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );

  // Get member count with proper plural form
  const getMemberCount = (group: Group) => {
    const count = group.members.length;
    return `${count} ${count === 1 ? 'member' : 'members'}`;
  };

  return (
    <div className="container mx-auto px-4 py-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-900">My Groups</h1>
        <button
          onClick={() => setShowCreateModal(true)}
          className="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <PlusIcon className="-ml-1 mr-2 h-5 w-5" aria-hidden="true" />
          Create Group
        </button>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {myGroups.map((group) => (
          <div
            key={group.id}
            className="relative bg-white rounded-lg shadow hover:shadow-md transition-shadow duration-200 overflow-hidden"
          >
            <div className="px-4 py-5 sm:p-6">
              <div className="flex items-center justify-between">
                <h3 className="text-lg font-medium text-gray-900">{group.name}</h3>
                <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                  {group.currency}
                </span>
              </div>
              
              <div className="mt-2 text-sm text-gray-500">
                {getMemberCount(group)}
              </div>

              <div className="mt-4">
                <div className="flex justify-between text-sm">
                  <span>Total Expenses</span>
                  <span className="font-medium">{group.currency} {getGroupTotal(group.id).toFixed(2)}</span>
                </div>
              </div>

              <div className="mt-4 flex -space-x-2 overflow-hidden">
                {group.members.slice(0, 5).map((member, idx) => (
                  <img
                    key={member.id}
                    className="inline-block h-8 w-8 rounded-full ring-2 ring-white"
                    src={member.avatar}
                    alt={member.name}
                  />
                ))}
                {group.members.length > 5 && (
                  <span className="inline-flex h-8 w-8 items-center justify-center rounded-full ring-2 ring-white bg-gray-100 text-xs font-medium">
                    +{group.members.length - 5}
                  </span>
                )}
              </div>

              <div className="mt-4">
                <button
                  type="button"
                  onClick={() => window.location.href = `/groups/${group.id}`}
                  className="w-full inline-flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  View Details
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Create Group Modal placeholder - will implement next */}
      {showCreateModal && (
        <div className="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center">
          <div className="bg-white rounded-lg p-6">
            <h2>Create New Group</h2>
            {/* Form will go here */}
            <button onClick={() => setShowCreateModal(false)}>Close</button>
          </div>
        </div>
      )}
    </div>
  );
}