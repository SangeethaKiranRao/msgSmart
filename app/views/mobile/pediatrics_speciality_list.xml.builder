xml.instruct!

xml.specialities do 
  @pedialtrics_list.each do |adult|
    xml.speciality(adult)
  end
end


