["C", "Ruby", "Rust", "R", "Python", "Javascript", "Java", "C#", "Ruskell", "Perl", "SQL", "Solidity", "Go", "Elixir", "Cobra", "MATLAB"].each do |language|
  Idea.create! title: "#{language}", body: "This is idea #{language}'s body'"
end

puts 'Test data created.'
