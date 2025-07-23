use customer_feedback;

db.feedback.insertMany([
  {
    customer_id: 1,
    feedback: "package arrived late. delay was frustrating.",
    timestamp: { "$date": "2024-07-20" }
  },
  {
    customer_id: 2,
    feedback: "excellent delivery time. very satisfied.",
    timestamp: { "$date": "2024-07-21" }
  },
  {
    customer_id: 3,
    feedback: "received wrong item. please improve.",
    timestamp: { "$date": "2024-07-22" }
  },
  {
    customer_id: 4,
    feedback: "tracking was not updating. confusing experience.",
    timestamp: { "$date": "2024-07-23" }
  },
  {
    customer_id: 5,
    feedback: "delivery was okay, but packaging was bad.",
    timestamp: { "$date": "2024-07-23" }
  }
]);

// Index created on customer_id to enable efficient search
db.feedback.createIndex({ customer_id: 1 });

db.feedback.find({ customer_id: 1 }); 
db.feedback.find({ customer_id: { $gt: 2 } });
