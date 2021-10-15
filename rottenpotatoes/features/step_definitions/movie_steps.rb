# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
      Movie.create(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.index(e1).should < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    if rating_list == "all"
		uratings = Movie.all_ratings
	else
		uratings = rating_list.split(", ")
	end
	uratings.each do | r |
		if uncheck
			uncheck("ratings_#{r}")
		else
			check("ratings_#{r}")
		end
	end
end
When /I should see the movies rated: (.*)/ do |rating_list|
  @movies = Movie.all  
  if rating_list == "all"
     given_ratings = Movie.all_ratings
  else
     given_ratings = rating_list.split(", ")
  end
  @movies.each do |movie|
    if given_ratings.include?(movie.rating)
      page.body.include?(movie.title).should == true
    else
      page.body.include?(movie.title).should == false
    end
  end
end

Then /I should see all the movies/ do
  @movies = Movie.all
  @movies.each do |movie|
      page.body.include?(movie.title).should == true
  end
end
