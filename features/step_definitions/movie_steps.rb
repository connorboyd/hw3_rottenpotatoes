# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  listOfRatings = rating_list.split(' ')
  if(uncheck)
    Movie.all_ratings.each do |rating|
      check("ratings_" + rating)
    end
    listOfRatings.each do |rating|
      uncheck("ratings_" + rating)
    end
  else
    Movie.all_ratings.each do |rating|
      uncheck("ratings_" + rating)
    end
    listOfRatings.each do |rating|
      check("ratings_" + rating)
    end
  end

  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end



Then /I should only see movies of the following ratings: (.*)/ do |ratings|
  listOfRatings = ratings.split(' ')
  shouldntSeeThese = Movie.all_ratings - listOfRatings

  listOfRatings.each do |rating|
    page.body.should match(/<td>#{rating}<\/td>/)
  end

  shouldntSeeThese.each do |rating|
    page.body.should_not match(/<td>#{rating}<\/td>/)
  end
end


When /^I (un)?check all ratings$/ do |uncheck|
  Movie.all_ratings.each do |rating|
    if uncheck
      uncheck("ratings_" + rating)
    else
      check("ratings_" + rating)
    end
  end
end
