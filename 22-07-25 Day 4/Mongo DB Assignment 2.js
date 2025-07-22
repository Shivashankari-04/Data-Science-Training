use movieDB

db.users.insertMany([
   { user_id: 1, name: "Ravi", email: "ravi@gmail.com", country: "India" },
  { user_id: 2, name: "Sara", email: "sara@yahoo.com", country: "USA" },
  { user_id: 3, name: "Meena", email: "meena@hotmail.com", country: "India" },
  { user_id: 4, name: "Alex", email: "alex@gmail.com", country: "UK" },
  { user_id: 5, name: "Liam", email: "liam@protonmail.com", country: "Canada" }
])


db.movies.insertMany([
   { movie_id: 101, title: "Inception", genre: "Sci-Fi", release_year: 2010, duration: 148 },
  { movie_id: 102, title: "The Matrix", genre: "Sci-Fi", release_year: 1999, duration: 136 },
  { movie_id: 103, title: "Interstellar", genre: "Sci-Fi", release_year: 2014, duration: 169 },
  { movie_id: 104, title: "Parasite", genre: "Thriller", release_year: 2019, duration: 132 },
  { movie_id: 105, title: "Soul", genre: "Animation", release_year: 2020, duration: 100 },
  { movie_id: 106, title: "Coco", genre: "Animation", release_year: 2017, duration: 105 }
])


db.watch_history.insertMany([
  { watch_id: 1, user_id: 1, movie_id: 101, watched_on: "2023-08-01", watch_time: 120 },
  { watch_id: 2, user_id: 2, movie_id: 102, watched_on: "2023-08-05", watch_time: 90 },
  { watch_id: 3, user_id: 1, movie_id: 103, watched_on: "2023-08-10", watch_time: 169 },
  { watch_id: 4, user_id: 3, movie_id: 101, watched_on: "2023-08-15", watch_time: 140 },
  { watch_id: 5, user_id: 3, movie_id: 105, watched_on: "2023-08-20", watch_time: 100 },
  { watch_id: 6, user_id: 4, movie_id: 106, watched_on: "2023-08-25", watch_time: 105 },
  { watch_id: 7, user_id: 5, movie_id: 104, watched_on: "2023-08-30", watch_time: 130 },
  { watch_id: 8, user_id: 1, movie_id: 101, watched_on: "2023-09-01", watch_time: 100 }
])

// Basic queries
// 1. Find all movies with duration > 100 minutes.

db.movies.find({ duration: { $gt: 100 } })


// 2. List users from 'India'.

db.users.find({country: "India"})


db.movies.insertOne({ movei_id: 107, title: "Oppenheimer", genre: "drama", release_year: 2023, duration:180})

// 3. Get all movies released after 2020.

db.movies.find({ release_year: { $gt: 2020} })

// Intermediate

// 4. Show full watch history: user name, movie title, watch time.

db.watch_history.aggregate([ 
  { $lookup:{
  from: "users",
  localField: "user_id",
  foreignField:"user_id",
  as: "user_info"
  }
},
  { $unwind: "$user_info"},
  {$lookup:{
    from:"movies",
    localField: "movie_id",
    foreignField: "movie_id",
    as: "movie_info"
    }
  },
  {$unwind: "$movie_info"},
  {$project: {
    _id:0,
    user:"$user_info.name",
    movie: "$movie_info.title",
    watch_time: 1
  }
  }
  ])


//  5. List each genre and number of times movies in that genre were watched.

db.watch_history.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "movie_id",
      as: "movie_info"
    }
  },
  {$unwind: "$movie_info"},
  {
    $group:{
      _id: "$movie_info.genre",
      times_watched: {$sum: 1}
    }
  }
])


 // 6. Display total watch time per user.

db.watch_history.aggregate([
  {
    $group: {
      _id: "$user_id",
      total_watch_time: { $sum: "$watch_time" }
    }
  },
  {
    $lookup: {
      from: "users",
      localField: "_id",
      foreignField: "user_id",
      as: "user_info"
    }
  },
  { $unwind: "$user_info" },
  {
    $project: {
      _id: 0,
      user: "$user_info.name",
      total_watch_time: 1
    }
  }
])


// Advanced

// 7. Find which movie has been watched the most (by count).

db.watch_history.aggregate([
  {
    $group: {
      _id: "$movie_id",
      watch_count: { $sum: 1 }
    }
  },
  {
    $lookup: {
      from: "movies",
      localField: "_id",
      foreignField: "movie_id",
      as: "movie_info"
    }
  },
  { $unwind: "$movie_info" },
  {
    $project: {
      movie_title: "$movie_info.title",
      watch_count: 1
    }
  },
  { $sort: { watch_count: -1 } },
  { $limit: 1 }
])


//  8. Identify users who have watched more than 2 movies.

db.watch_history.aggregate([
  {
    $group: {
      _id: "$user_id",
      unique_movies: { $addToSet: "$movie_id" }
    }
  },
  {
    $project: {
      movie_count: { $size: "$unique_movies" }
    }
  },
  {
    $match: {
      movie_count: { $gt: 2 }
    }
  }
])


 // 9. Show users who watched the same movie more than once.

db.watch_history.aggregate([
  {
    $group:{
      _id: {user_id: "$user_id",movie_id: "$movie_id"},
      watch_count: { $sum: 1}
    }
  },
  {
    $match: {
      watch_count: { $gt: 1}
    }
  }
])


 // 10. Calculate percentage of each movie watched compared to its full duration (watch_time/duration * 100 )

db.watch_history.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "movie_id",
      as: "movie_info"
    }
  },
  {$unwind: "$movie_info" },
  {
    $project: {
      user_id: 1,
      movie_id: 1,
      movie_title: "$movie_info.title",
      watch_time: 1,
      duration: "$movie_info.duration",
      percent_watched: { $multiply: [{ $divide: ["$watch_time", "$movie_info.duration"] },100]
      }
    }
  }
])
