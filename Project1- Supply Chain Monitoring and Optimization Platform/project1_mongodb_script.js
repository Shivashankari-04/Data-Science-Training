// Use database
use supply_chain_db

// Create collection (optional)
db.createCollection("shipments")

// Insert shipment documents
db.shipments.insertMany([
  {
    shipment_id: "S001",
    order_id: 1,
    shipped_date: "2025-07-15",
    delivered_date: "2025-07-19",
    status: "Delivered",
    location: { lat: 12.9716, lng: 77.5946 }
  },
  {
    shipment_id: "S002",
    order_id: 2,
    shipped_date: "2025-07-18",
    delivered_date: null,
    status: "In Transit",
    location: { lat: 19.0760, lng: 72.8777 }
  },
  {
    shipment_id: "S003",
    order_id: 3,
    shipped_date: "2025-07-10",
    delivered_date: "2025-07-12",
    status: "Delivered",
    location: { lat: 28.6139, lng: 77.2090 }
  }
])

// Create indexes
db.shipments.createIndex({ order_id: 1 })
db.shipments.createIndex({ status: 1 })