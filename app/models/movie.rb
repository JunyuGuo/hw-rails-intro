class Movie < ActiveRecord::Base
    def self.get_all_ratings
	    return %w[G PG-13 PG R]
    end

    def self.with_ratings(ratings)
        Movie.where(rating: ratings.keys)
    end
end