use job_portaldb


db.jobs.insertMany([
  { job_id: 1, job_title: "Backend Developer", company: "CodeCraft", location: "Hyderabad", salary: 1200000, job_type: "remote", posted_on: new Date("2025-07-01") },
  { job_id: 2, job_title: "Data Analyst", company: "InsightWorks", location: "Delhi", salary: 950000, job_type: "on-site", posted_on: new Date("2025-07-10") },
  { job_id: 3, job_title: "DevOps Engineer", company: "CloudNet", location: "Bangalore", salary: 1400000, job_type: "hybrid", posted_on: new Date("2025-07-05") },
  { job_id: 4, job_title: "Frontend Developer", company: "CodeCraft", location: "Hyderabad", salary: 1000000, job_type: "remote", posted_on: new Date("2025-07-15") },
  { job_id: 5, job_title: "UI/UX Designer", company: "DesignHub", location: "Pune", salary: 900000, job_type: "on-site", posted_on: new Date("2025-07-08") },
  { job_id: 6, job_title: "QA Tester", company: "BugTrackers", location: "Chennai", salary: 800000, job_type: "on-site", posted_on: new Date("2025-07-20") }
])


db.applicants.insertMany([
  { applicant_id: 101, name: "Ravi Mehta", skills: ["MongoDB", "Node.js", "JavaScript"], experience: 3, city: "Hyderabad", applied_on: new Date("2025-07-16") },
  { applicant_id: 102, name: "Sneha Kapoor", skills: ["Python", "MongoDB", "Tableau"], experience: 2, city: "Mumbai", applied_on: new Date("2025-07-18") },
  { applicant_id: 103, name: "Aman Gupta", skills: ["AWS", "Terraform", "Docker"], experience: 5, city: "Bangalore", applied_on: new Date("2025-07-12") },
  { applicant_id: 104, name: "Nikita Rao", skills: ["Figma", "CSS", "UX Research"], experience: 1, city: "Delhi", applied_on: new Date("2025-07-20") },
  { applicant_id: 105, name: "Karan Joshi", skills: ["Java", "Spring", "MongoDB"], experience: 4, city: "Hyderabad", applied_on: new Date("2025-07-17") },
  { applicant_id: 106, name: "Zoya Khan", skills: ["HTML", "CSS"], experience: 1, city: "Kolkata", applied_on: new Date("2025-07-21") }
])


db.applications.insertMany([
  { application_id: 201, applicant_id: 101, job_id: 1, application_status: "interview scheduled", interview_scheduled: new Date("2025-07-24"), feedback: "Strong in backend" },
  { application_id: 202, applicant_id: 102, job_id: 2, application_status: "applied", interview_scheduled: null, feedback: null },
  { application_id: 203, applicant_id: 103, job_id: 3, application_status: "rejected", interview_scheduled: null, feedback: "Needs Kubernetes" },
  { application_id: 204, applicant_id: 104, job_id: 5, application_status: "interview scheduled", interview_scheduled: new Date("2025-07-25"), feedback: "Creative thinker" },
  { application_id: 205, applicant_id: 105, job_id: 1, application_status: "applied", interview_scheduled: null, feedback: null },
  { application_id: 206, applicant_id: 105, job_id: 4, application_status: "applied", interview_scheduled: null, feedback: null }
])


// 1. Find all remote jobs with a salary greater than 10,00,000.

db.jobs.find({ job_type: "remote", salary: { $gt: 1000000 } })


// 2. Get all applicants who know MongoDB.

db.applicants.find({ skills: "MongoDB" })


// 3. Show the number of jobs posted in the last 30 days.

db.jobs.aggregate([
  { $match: { posted_on: { $gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) } } },
  { $count: "jobs_last_30_days" }
])


// 4. List all job applications that are in ‘interview scheduled’ status.

db.applications.find({ application_status: "interview scheduled" })


// 5. Find companies that have posted more than 2 jobs.

db.jobs.aggregate([
  { $group: { _id: "$company", job_count: { $sum: 1 } } },
  { $match: { job_count: { $gt: 2 } } }
])


// 6. Join applications with jobs to show job title along with the applicant’s 
name.

db.applications.aggregate([
  { $lookup: {
      from: "jobs",
      localField: "job_id",
      foreignField: "job_id",
      as: "job_info"
  }},
  { $lookup: {
      from: "applicants",
      localField: "applicant_id",
      foreignField: "applicant_id",
      as: "applicant_info"
  }},
  { $unwind: "$job_info" },
  { $unwind: "$applicant_info" },
  { $project: {
      job_title: "$job_info.job_title",
      applicant_name: "$applicant_info.name"
  }}
])


// 7. Find how many applications each job has received.

db.applications.aggregate([
  { $group: {
      _id: "$job_id",
      application_count: { $sum: 1 }
  }}
])


// 8. List applicants who have applied for more than one job.

db.applications.aggregate([
  { $group: {
      _id: "$applicant_id",
      total_applications: { $sum: 1 }
  }},
  { $match: { total_applications: { $gt: 1 } }},
  { $lookup: {
      from: "applicants",
      localField: "_id",
      foreignField: "applicant_id",
      as: "applicant_info"
  }},
  { $unwind: "$applicant_info" },
  { $project: {
      applicant_name: "$applicant_info.name",
      total_applications: 1
  }}
])


// 9. Show the top 3 cities with the most applicants.

db.applicants.aggregate([
  { $group: {
      _id: "$city",
      applicant_count: { $sum: 1 }
  }},
  { $sort: { applicant_count: -1 } },
  { $limit: 3 }
])

// 10. Get the average salary for each job type (remote, hybrid, on-site).

db.jobs.aggregate([
  { $group: {
      _id: "$job_type",
      avg_salary: { $avg: "$salary" }
  }}
])


// 11. Update the status of one application to "offer made".

db.applications.updateOne(
  { application_status: "interview scheduled" },
  { $set: { application_status: "offer made" } }
)


// 12. Delete a job that has not received any applications.

db.jobs.aggregate([
  { $lookup: {
      from: "applications",
      localField: "job_id",
      foreignField: "job_id",
      as: "apps"
  }},
  { $match: { apps: { $eq: [] } } }
])

db.jobs.deleteOne({ job_id: 6 })


// 13. Add a new field shortlisted to all applications and set it to false.

db.applications.updateMany({}, { $set: { shortlisted: false } })


// 14. Increment experience of all applicants from "Hyderabad" by 1 year.

db.applicants.updateMany(
  { city: "Hyderabad" },
  { $inc: { experience: 1 } }
)


// 15. Delete all applicants who haven’t applied to any job.

db.applicants.aggregate([
  { $lookup: {
      from: "applications",
      localField: "applicant_id",
      foreignField: "applicant_id",
      as: "apps"
  }},
  { $match: { apps: { $eq: [] } } }
])

db.applicants.deleteOne({ applicant_id: 106 })
