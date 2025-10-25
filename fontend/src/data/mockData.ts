/*
  Extended mock data for the Expense Splitter frontend.
  This file provides richer test data and small helper functions so the UI can
  be developed without a backend. Treat these exports as a temporary local
  "mock API". When you're ready to replace with a real API, swap calls to the
  helper functions with network requests.

  Contains:
  - Users, Groups, Expenses (including recurring and multi-currency examples)
  - Transactions / Payments
  - Receipt placeholders (receiptImageUrl, ocrText)
  - Categories with icons
  - Helper functions: fetch*() and settlement suggestion algorithm
*/

export interface User {
  id: string;
  name: string;
  email: string;
  avatar: string;
}

export interface Group {
  id: string;
  name: string;
  members: User[];
  createdAt: string; // ISO date
  currency: string; // e.g. 'USD', 'VND', 'EUR'
  notes?: string;
}

export interface SplitItem {
  userId: string;
  amount: number;
}

export type RecurringFrequency = 'weekly' | 'monthly' | 'yearly';

export interface RecurringExpense {
  frequency: RecurringFrequency;
  nextDate: string;
}

export interface Expense {
  id: string;
  groupId: string;
  paidBy: string; // userId
  amount: number;
  currency?: string;
  description: string;
  category: string;
  tags?: string[];
  date: string; // ISO
  split: SplitItem[];
  receiptImageUrl?: string; // placeholder to show attachment UI
  ocrText?: string; // simulated OCR text
  note?: string; // manual note
  recurring?: RecurringExpense;
}

// Mock Users Data
export const mockUsers: User[] = [
  {
    id: "u1",
    name: "Nguyễn Văn A",
    email: "nguyenvana@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=1"
  },
  {
    id: "u2",
    name: "Trần Thị B",
    email: "tranthib@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=2"
  },
  {
    id: "u3",
    name: "Lê Văn C",
    email: "levanc@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=3"
  },
  {
    id: "u4",
    name: "Phạm Thị D",
    email: "phamthid@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=4"
  },
  {
    id: "u5",
    name: "Hoàng Văn E",
    email: "hoangvane@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=5"
  },
  {
    id: "u6",
    name: "Vũ Thị F",
    email: "vuthif@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=6"
  },
  {
    id: "u7",
    name: "Đỗ Văn G",
    email: "dovang@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=7"
  },
  {
    id: "u8",
    name: "Mai Thị H",
    email: "maithih@gmail.com",
    avatar: "https://i.pravatar.cc/150?img=8"
  }
];

// Mock Groups Data
export const mockGroups: Group[] = [
  {
    id: "g1",
    name: "Du lịch Đà Lạt",
    members: [mockUsers[0], mockUsers[1], mockUsers[2], mockUsers[4]],
    createdAt: "2025-10-20T00:00:00Z",
    currency: "VND",
    notes: "Chuyến đi Đà Lạt tháng 11/2025"
  },
  {
    id: "g2", 
    name: "Ăn trưa văn phòng",
    members: [mockUsers[1], mockUsers[2], mockUsers[3]],
    createdAt: "2025-10-15T00:00:00Z",
    currency: "VND",
    notes: "Chi phí ăn trưa cùng đồng nghiệp"
  },
  {
    id: "g3",
    name: "Tiệc sinh nhật",
    members: [mockUsers[0], mockUsers[3], mockUsers[5], mockUsers[6], mockUsers[7]],
    createdAt: "2025-10-22T00:00:00Z",
    currency: "VND",
    notes: "Tiệc sinh nhật tại nhà hàng"
  },
  {
    id: "g4",
    name: "Dự án freelance",
    members: [mockUsers[2], mockUsers[4], mockUsers[5]],
    createdAt: "2025-09-15T00:00:00Z",
    currency: "USD",
    notes: "Chi phí cho dự án freelance"
  },
  {
    id: "g5",
    name: "Chia sẻ nhà thuê",
    members: [mockUsers[1], mockUsers[4], mockUsers[7]],
    createdAt: "2025-08-01T00:00:00Z",
    currency: "VND",
    notes: "Chi phí thuê nhà và utility hàng tháng"
  }
];

// Mock Expenses Data
export const mockExpenses: Expense[] = [
  // Nhóm Du lịch Đà Lạt
  {
    id: "e1",
    groupId: "g1",
    paidBy: "u1",
    amount: 1500000,
    currency: "VND",
    description: "Tiền khách sạn 2 đêm",
    category: "Chỗ ở",
    date: "2025-11-01T00:00:00Z",
    split: [
      { userId: "u1", amount: 375000 },
      { userId: "u2", amount: 375000 },
      { userId: "u3", amount: 375000 },
      { userId: "u5", amount: 375000 }
    ],
    receiptImageUrl: "https://example.com/receipts/hotel.jpg",
    tags: ["khách sạn", "đặt phòng"]
  },
  {
    id: "e2",
    groupId: "g1",
    paidBy: "u2",
    amount: 900000,
    currency: "VND",
    description: "Tiền ăn uống ngày 1",
    category: "Ăn uống",
    date: "2025-11-02T00:00:00Z",
    split: [
      { userId: "u1", amount: 225000 },
      { userId: "u2", amount: 225000 },
      { userId: "u3", amount: 225000 },
      { userId: "u5", amount: 225000 }
    ],
    tags: ["nhà hàng", "ăn tối"]
  },
  {
    id: "e3",
    groupId: "g1",
    paidBy: "u5",
    amount: 1200000,
    currency: "VND",
    description: "Tour tham quan thành phố",
    category: "Di chuyển",
    date: "2025-11-02T00:00:00Z",
    split: [
      { userId: "u1", amount: 300000 },
      { userId: "u2", amount: 300000 },
      { userId: "u3", amount: 300000 },
      { userId: "u5", amount: 300000 }
    ],
    tags: ["tour", "tham quan"]
  },

  // Nhóm Ăn trưa văn phòng
  {
    id: "e4",
    groupId: "g2",
    paidBy: "u2",
    amount: 150000,
    currency: "VND",
    description: "Cơm trưa 25/10",
    category: "Ăn uống",
    date: "2025-10-25T00:00:00Z",
    split: [
      { userId: "u2", amount: 50000 },
      { userId: "u3", amount: 50000 },
      { userId: "u4", amount: 50000 }
    ],
    recurring: {
      frequency: 'weekly',
      nextDate: '2025-11-01T00:00:00Z'
    }
  },

  // Nhóm Tiệc sinh nhật
  {
    id: "e5",
    groupId: "g3",
    paidBy: "u1",
    amount: 2500000,
    currency: "VND",
    description: "Đặt tiệc nhà hàng",
    category: "Ăn uống",
    date: "2025-10-22T00:00:00Z",
    split: [
      { userId: "u1", amount: 500000 },
      { userId: "u4", amount: 500000 },
      { userId: "u6", amount: 500000 },
      { userId: "u7", amount: 500000 },
      { userId: "u8", amount: 500000 }
    ],
    receiptImageUrl: "https://example.com/receipts/party.jpg",
    tags: ["sinh nhật", "tiệc"]
  },

  // Nhóm Dự án freelance
  {
    id: "e6",
    groupId: "g4",
    paidBy: "u5",
    amount: 500,
    currency: "USD",
    description: "License phần mềm",
    category: "Khác",
    date: "2025-09-20T00:00:00Z",
    split: [
      { userId: "u3", amount: 166.67 },
      { userId: "u5", amount: 166.67 },
      { userId: "u6", amount: 166.66 }
    ],
    tags: ["phần mềm", "công cụ"]
  },

  // Nhóm Chia sẻ nhà thuê
  {
    id: "e7",
    groupId: "g5",
    paidBy: "u2",
    amount: 9000000,
    currency: "VND",
    description: "Tiền thuê nhà tháng 10",
    category: "Chỗ ở",
    date: "2025-10-01T00:00:00Z",
    split: [
      { userId: "u2", amount: 3000000 },
      { userId: "u5", amount: 3000000 },
      { userId: "u8", amount: 3000000 }
    ],
    recurring: {
      frequency: 'monthly',
      nextDate: '2025-11-01T00:00:00Z'
    },
    tags: ["tiền nhà"]
  },
  {
    id: "e8",
    groupId: "g5",
    paidBy: "u5",
    amount: 900000,
    currency: "VND",
    description: "Tiền điện nước tháng 10",
    category: "Khác",
    date: "2025-10-05T00:00:00Z",
    split: [
      { userId: "u2", amount: 300000 },
      { userId: "u5", amount: 300000 },
      { userId: "u8", amount: 300000 }
    ],
    recurring: {
      frequency: 'monthly',
      nextDate: '2025-11-05T00:00:00Z'
    },
    tags: ["utility", "hóa đơn"]
  }
];

// Helper functions
export const calculateGroupTotal = (groupId: string): number => {
  return mockExpenses
    .filter(expense => expense.groupId === groupId)
    .reduce((total, expense) => total + expense.amount, 0);
};

export const calculateUserBalance = (userId: string): {
  totalOwed: number;
  totalOwes: number;
} => {
  let totalOwed = 0;
  let totalOwes = 0;

  mockExpenses.forEach(expense => {
    // If user paid for the expense
    if (expense.paidBy === userId) {
      const userSplit = expense.split.find(split => split.userId === userId);
      const userAmount = userSplit ? userSplit.amount : 0;
      totalOwed += expense.amount - userAmount;
    }
    // If user needs to pay their split
    const userSplit = expense.split.find(split => split.userId === userId);
    if (userSplit && expense.paidBy !== userId) {
      totalOwes += userSplit.amount;
    }
  });

  return { totalOwed, totalOwes };
};

// Expense Categories
export const expenseCategories = [
  "Ăn uống",
  "Chỗ ở",
  "Di chuyển",
  "Mua sắm",
  "Giải trí",
  "Khác"
];

export interface Payment {
  id: string;
  fromUser: string;
  toUser: string;
  amount: number;
  currency?: string;
  groupId?: string;
  provider?: 'VNPAY' | 'BANK_TRANSFER' | 'CASH';
  status: 'pending' | 'completed' | 'failed';
  date: string;
  note?: string;
}

export interface SettlementSuggestion {
  from: string;
  to: string;
  amount: number;
}

// -- Mock users
export const users: User[] = [
  { id: 'u1', name: 'John Doe', email: 'john@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=John' },
  { id: 'u2', name: 'Jane Smith', email: 'jane@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jane' },
  { id: 'u3', name: 'Mike Johnson', email: 'mike@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Mike' },
  { id: 'u4', name: 'Sarah Williams', email: 'sarah@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah' },
  { id: 'u5', name: 'Linh Nguyen', email: 'linh@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Linh' },
  { id: 'u6', name: 'An Tran', email: 'an@example.com', avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=An' },
];

// -- Mock groups
export const groups: Group[] = [
  { id: 'g1', name: 'Vacation Trip', members: [users[0], users[1], users[2]], createdAt: '2025-10-20', currency: 'USD', notes: 'Trip to Thailand 2025' },
  { id: 'g2', name: 'House Expenses', members: [users[0], users[1], users[3]], createdAt: '2025-10-15', currency: 'USD', notes: 'Shared apartment bills' },
  { id: 'g3', name: 'Office Team', members: [users[0], users[2], users[4], users[5]], createdAt: '2025-01-10', currency: 'VND', notes: 'Monthly office costs' },
];

// -- Categories
export const categories = [
  { id: 'food', name: 'Food & Drinks', icon: '🍽️' },
  { id: 'accommodation', name: 'Accommodation', icon: '🏨' },
  { id: 'transport', name: 'Transport', icon: '🚗' },
  { id: 'shopping', name: 'Shopping', icon: '🛍️' },
  { id: 'entertainment', name: 'Entertainment', icon: '🎮' },
  { id: 'utilities', name: 'Utilities', icon: '💡' },
  { id: 'other', name: 'Other', icon: '📦' },
];

// -- Richer expenses (equal and unequal splits, multi-currency, recurring)
export const expenses: Expense[] = [
  {
    id: 'e1',
    groupId: 'g1',
    paidBy: 'u1',
    amount: 120,
    currency: 'USD',
    description: 'Dinner at Restaurant',
    category: 'food',
    tags: ['dinner', 'seafood'],
    date: '2025-10-23',
    split: [
      { userId: 'u1', amount: 40 },
      { userId: 'u2', amount: 40 },
      { userId: 'u3', amount: 40 },
    ],
    receiptImageUrl: 'https://placehold.co/600x400?text=receipt-e1',
    ocrText: 'Restaurant ABC - Total 120.00 USD - Thank you!',
    note: 'Had a welcome dinner; tip included'
  },
  {
    id: 'e2',
    groupId: 'g1',
    paidBy: 'u2',
    amount: 300,
    currency: 'USD',
    description: 'Hotel Booking',
    category: 'accommodation',
    date: '2025-10-22',
    split: [
      { userId: 'u1', amount: 100 },
      { userId: 'u2', amount: 100 },
      { userId: 'u3', amount: 100 },
    ],
    note: '3 nights, pre-paid'
  },
  {
    id: 'e3',
    groupId: 'g2',
    paidBy: 'u1',
    amount: 80,
    currency: 'USD',
    description: 'Groceries',
    category: 'shopping',
    date: '2025-10-24',
    split: [
      { userId: 'u1', amount: 26.67 },
      { userId: 'u2', amount: 26.67 },
      { userId: 'u4', amount: 26.66 },
    ],
    note: 'Weekly groceries at SuperMart',
    recurring: { frequency: 'weekly', nextDate: '2025-10-31' },
  },
  {
    id: 'e4',
    groupId: 'g3',
    paidBy: 'u5',
    amount: 2500000,
    currency: 'VND',
    description: 'Office Electricity Bill',
    category: 'utilities',
    date: '2025-10-05',
    split: [
      { userId: 'u0', amount: 0 }, // placeholder to show uneven splits handled later
      { userId: 'u2', amount: 625000 },
      { userId: 'u4', amount: 625000 },
      { userId: 'u5', amount: 1250000 },
    ],
    note: 'Split by usage; An covered 50% this month',
    receiptImageUrl: 'https://placehold.co/600x400?text=receipt-e4',
    ocrText: 'EVN Bill - Total: 2,500,000 VND',
    recurring: { frequency: 'monthly', nextDate: '2025-11-05' },
  },
  {
    id: 'e5',
    groupId: 'g3',
    paidBy: 'u6',
    amount: 500000,
    currency: 'VND',
    description: 'Team lunch',
    category: 'food',
    date: '2025-09-30',
    split: [
      { userId: 'u0', amount: 0 },
      { userId: 'u2', amount: 125000 },
      { userId: 'u4', amount: 125000 },
      { userId: 'u5', amount: 250000 },
    ],
    note: 'Farewell lunch for intern'
  },
];

// -- Payments / Transactions
export const payments: Payment[] = [
  { id: 'p1', fromUser: 'u2', toUser: 'u1', amount: 140, currency: 'USD', groupId: 'g1', provider: 'BANK_TRANSFER', status: 'pending', date: '2025-10-24', note: 'Payment for hotel share' },
  { id: 'p2', fromUser: 'u3', toUser: 'u1', amount: 140, currency: 'USD', groupId: 'g1', provider: 'BANK_TRANSFER', status: 'completed', date: '2025-10-23' },
  { id: 'p3', fromUser: 'u2', toUser: 'u1', amount: 26.67, currency: 'USD', groupId: 'g2', provider: 'VNPAY', status: 'pending', date: '2025-10-24' },
];

// -- Helper functions to act like a small mock API
export function fetchUsers(): Promise<User[]> {
  return Promise.resolve(users);
}

export function fetchGroups(): Promise<Group[]> {
  return Promise.resolve(groups);
}

export function fetchExpenses(groupId?: string): Promise<Expense[]> {
  if (groupId) return Promise.resolve(expenses.filter((e) => e.groupId === groupId));
  return Promise.resolve(expenses);
}

export function fetchPayments(groupId?: string): Promise<Payment[]> {
  if (groupId) return Promise.resolve(payments.filter((p) => p.groupId === groupId));
  return Promise.resolve(payments);
}

// Compute per-user net balances within a group: positive = others owe this user
export function computeBalances(groupId: string) {
  const group = groups.find((g) => g.id === groupId);
  if (!group) return {} as Record<string, number>;
  const memberIds = group.members.map((m) => m.id);
  const bal: Record<string, number> = {};
  memberIds.forEach((id) => (bal[id] = 0));

  expenses.filter((e) => e.groupId === groupId).forEach((e) => {
    // payer gets +amount, then subtract each split share
    bal[e.paidBy] = (bal[e.paidBy] || 0) + e.amount;
    e.split.forEach((s) => {
      bal[s.userId] = (bal[s.userId] || 0) - s.amount;
    });
  });

  // apply completed payments
  payments.filter((p) => p.groupId === groupId && p.status === 'completed').forEach((p) => {
    bal[p.fromUser] = (bal[p.fromUser] || 0) - p.amount;
    bal[p.toUser] = (bal[p.toUser] || 0) + p.amount;
  });

  return bal;
}

// Simple greedy settlement: creditors (positive) receive from debtors (negative)
export function suggestSettlements(groupId: string): SettlementSuggestion[] {
  const balances = computeBalances(groupId);
  const entries = Object.entries(balances).map(([userId, amount]) => ({ userId, amount }));
  const creditors = entries.filter((e) => e.amount > 0).sort((a, b) => b.amount - a.amount);
  const debtors = entries.filter((e) => e.amount < 0).sort((a, b) => a.amount - b.amount);
  const suggestions: SettlementSuggestion[] = [];

  let i = 0;
  let j = 0;
  while (i < debtors.length && j < creditors.length) {
    const debtor = debtors[i];
    const creditor = creditors[j];
    const pay = Math.min(creditor.amount, -debtor.amount);
    if (pay <= 0) break;
    suggestions.push({ from: debtor.userId, to: creditor.userId, amount: Math.round(pay * 100) / 100 });
    debtor.amount += pay;
    creditor.amount -= pay;
    if (Math.abs(debtor.amount) < 0.01) i++;
    if (Math.abs(creditor.amount) < 0.01) j++;
  }

  return suggestions;
}

// Export a convenience function that mimics a grouped API response
export function getMockApi() {
  return Promise.resolve({ users, groups, expenses, payments, categories });
}
