module TimeBasicInformationsHelper
  
  def get_time_basic_information
    return TimeBasicInformation.first.id    
  end
end
