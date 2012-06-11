namespace :load do

  require 'fastercsv'

  desc "load specialty data from csv"
  task :specialties  => :environment do
    FasterCSV.foreach("lib/tasks/specialties.csv") do |row|
      Speciality.create(:name => row[0])
    end
  end

  desc "load medical group data"
  task :medical_groups  => :environment do
    MedicalGroup.create(:name => "Elmhurst Memorial Medical Associates")
    MedicalGroup.create(:name => "DuPage Medical Group")
    MedicalGroup.create(:name => "Sutter Medical Group")
  end
end