class Movie < ActiveRecord::Base
    def self.ratings_collection
        @@ratings_list = self.select(:rating).distinct
        ratings = []
        @@ratings_list.each do |rating|
            ratings.push(rating.rating)
        end
        return ratings
    end    
end
