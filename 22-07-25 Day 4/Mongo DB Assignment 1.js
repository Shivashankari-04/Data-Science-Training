use bookstoreDB


db.books.insertMany([
  { book_id: 101, title: "The AI Revolution", author: "Ray Kurzweil", genre: "Technology", price: 799, stock: 20 },
  { book_id: 102, title: "Midnight Library", author: "Matt Haig", genre: "Fiction", price: 499, stock: 15 },
  { book_id: 103, title: "Deep Work", author: "Cal Newport", genre: "Self-help", price: 650, stock: 10 },
  { book_id: 104, title: "Sapiens", author: "Yuval Noah Harari", genre: "History", price: 899, stock: 25 },
  { book_id: 105, title: "Atomic Habits", author: "James Clear", genre: "Self-help", price: 550, stock: 18 }
])


db.customers.insertMany([
  { customer_id: 1, name: "Anita", email: "anita@example.com", city: "Hyderabad" },
  { customer_id: 2, name: "Ramesh", email: "ramesh@example.com", city: "Delhi" },
  { customer_id: 3, name: "Farah", email: "farah@example.com", city: "Hyderabad" },
  { customer_id: 4, name: "John", email: "john@example.com", city: "Mumbai" },
  { customer_id: 5, name: "Meera", email: "meera@example.com", city: "Chennai" }
])


db.orders.insertMany([
  { order_id: 201, customer_id: 1, book_id: 101, order_date: "2023-01-10", quantity: 2 },
  { order_id: 202, customer_id: 2, book_id: 102, order_date: "2023-02-15", quantity: 1 },
  { order_id: 203, customer_id: 1, book_id: 103, order_date: "2023-03-20", quantity: 1 },
  { order_id: 204, customer_id: 3, book_id: 104, order_date: "2024-01-05", quantity: 2 },
  { order_id: 205, customer_id: 4, book_id: 105, order_date: "2024-05-01", quantity: 3 },
  { order_id: 206, customer_id: 5, book_id: 101, order_date: "2024-06-10", quantity: 1 },
  { order_id: 207, customer_id: 1, book_id: 104, order_date: "2024-07-01", quantity: 2 }
])


 // Basic Queries:

 // 1. List all books priced above 500.

db.books.find({ price: { $gt: 500 } })


 // 2. Show all customers from ‘Hyderabad’.

db.customers.find({ city: "Hyderabad" })


// 3. Find all orders placed after January 1, 2023.

db.orders.find({ order_date: { $gt: "2023-01-01" } })


// Joins via $lookup :
// 4. Display order details with customer name and book title.

db.orders.aggregate([
  { $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "customer_id",
      as: "customer_info"
  }},
  { $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "book_id",
      as: "book_info"
  }},
  { $project: {
      _id: 0,
      order_id: 1,
      quantity: 1,
      customer_name: { $arrayElemAt: ["$customer_info.name", 0] },
      book_title: { $arrayElemAt: ["$book_info.title", 0] }
  }}
])


//  5. Show total quantity ordered for each book.

db.orders.aggregate([
  { $group: {
      _id: "$book_id",
      total_quantity: { $sum: "$quantity" }
  }}
])


// 6. Show the total number of orders placed by each customer.

db.orders.aggregate([
  { $group: {
      _id: "$customer_id",
      total_orders: { $sum: 1 }
  }}
])


// Aggregation Queries:
 // 7. Calculate total revenue generated per book.

db.orders.aggregate([
  { $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "book_id",
      as: "book_info"
  }},
  { $unwind: "$book_info" },
  { $project: {
      book_id: 1,
      revenue: { $multiply: ["$quantity", "$book_info.price"] }
  }},
  { $group: {
      _id: "$book_id",
      total_revenue: { $sum: "$revenue" }
  }}
])


//  8. Find the book with the highest total revenue.

db.orders.aggregate([
  { $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "book_id",
      as: "book_info"
  }},
  { $unwind: "$book_info" },
  { $project: {
      title: "$book_info.title",
      revenue: { $multiply: ["$quantity", "$book_info.price"] }
  }},
  { $group: {
      _id: "$title",
      total_revenue: { $sum: "$revenue" }
  }},
  { $sort: { total_revenue: -1 } },
  { $limit: 1 }
])


// 9. List genres and total books sold in each genre.
 
db.orders.aggregate([
  { $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "book_id",
      as: "book_info"
  }},
  { $unwind: "$book_info" },
  { $group: {
      _id: "$book_info.genre",
      total_sold: { $sum: "$quantity" }
  }}
])


//  10. Show customers who ordered more than 2 different books.

db.orders.aggregate([
  { $group: {
      _id: "$customer_id",
      unique_books: { $addToSet: "$book_id" }
  }},
  { $project: {
      book_count: { $size: "$unique_books" }
  }},
  { $match: {
      book_count: { $gt: 2 }
  }}
])
