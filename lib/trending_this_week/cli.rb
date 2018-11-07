class TrendingThisWeek::CLI

  def call
  puts  'Welcome to trending spots where you can see the top trending spots from the tops cities in the US'
    cities
  end

  def cities
    @spots_array = nil
    puts " Please pick a city
    1. NYC
    2. Los Angeles
    3. Chicago
    4. San Francisco
    5. Austin"
    picked_city = STDIN.gets.strip
    @city_name = nil
    @url = 'https://foursquare.com/foursquare/list/trending-this-week-'
    case picked_city
      when '1'
        @city_name = 'NYC'
        @url << "new-york-city"
      when '2'
        @city_name = 'Los Angeles'
        @url << "los-angeles"
      when '3'
        @city_name = 'Chicago'
        @url << "chicago"
      when '4'
        @city_name = 'San Francisco'
        @url << "san-francisco"
      when '5'
        @city_name = 'Austin'
        @url << "austin"
      when 'exit'
        goodbye
      else
        puts "I didn't get that, please try again!"
        cities
      end
      get_spots
    end

  def list_spots
      @spots_array = TrendingThisWeek::Spots.all.each do |spot|
      if !spot.location.empty?
            puts "#{spot.rank}. #{spot.name} - #{spot.type} - #{spot.location}"
          else
            puts "#{spot.rank}. #{spot.name} - #{spot.type}"
        end
      end
    more_info
  end

  def get_spots
      puts "Here are the top spots in #{@city_name}"
       TrendingThisWeek::Spots.this_week(@url).each do |spot|
       end
       list_spots
  end


  def more_info
    puts "Enter a number matching a Trending Spot for more information, type 'city' to see the available cities or type exit"
    user_input = STDIN.gets.strip
        if user_input == 'city'
          cities
        elsif user_input == 'exit'
          goodbye
        elsif user_input.to_i > 0 && user_input.to_i <= @spots_array.length
          user_pick = @spots_array[user_input.to_i-1]
          TrendingThisWeek::Spots.spot_more_info(user_pick)
          additional_info(user_pick)
        else
          puts "I didn't get that please try again :)"
          more_info
        end
  end


  def list_info(spot_instance, spot_info)
    spot_info = spot_info.strip
      case spot_info
        when '1'
          check_if_info(spot_instance,spot_instance.phone_number)
        when '2'
          check_if_info(spot_instance, spot_instance.address)
        when '3'
         check_if_info(spot_instance, spot_instance.city)
        when '4'
            feature(spot_instance)
            additional_info(spot_instance)
        when 'all'
          puts <<~HEREDOC
          Rank #{spot_instance.rank} - #{spot_instance.name} - #{spot_instance.type}
          Address: #{spot_instance.address} - #{spot_instance.location} - #{spot_instance.city}
          Phone: #{spot_instance.phone_number}
          HEREDOC
          "#{feature(spot_instance)}\n\n"
          city_or_spots
        when 'exit'
          goodbye
        when 'city'
          cities
        when 'list'
          list_spots
        else
          puts "I didn't get that please try again"
          spot_info = gets.strip

        end
  end

  def check_if_info(instance, info)
    if  info.empty?
      puts "Seems we don't have that information. Please try again!\n\n"
     additional_info(instance)
    else
      puts "#{info}"
      additional_info(instance)
  end
end

  def city_or_spots
    puts "Would you like to see a list of the 'spots', 'cities' or 'exit'?"
    user_input = gets.strip.downcase
      if user_input  == 'spots'
          list_spots
      elsif user_input == 'cities'
          cities
      elsif user_input == 'exit'
        goodbye
      else
        puts "I didn't get that please try again."
      end
  end


  def feature(instance)
    if instance.features.length > 0
      puts "Additional Information:"
        instance.features.each do | feature|
          puts "#{feature}"
        end
      else
        puts "Seems we don't have that any additional information"
    end
  end

  def goodbye
    puts 'See you next time!'
  end

  def additional_info(instance)
    puts "What additional information would you like to know about #{instance.name}?
    1. Phone number
    2. Address
    3. City
    4. Features

    Type 'all' to list all the info or 'city' to see a list of the available cites.
    Type 'exit' at any time to leave"
    user_choice = gets.strip
    list_info(instance,user_choice)
  end

end
