app = proc do |env|
	system('touch ./tmp/deploy.txt')
  [200, { "Content-Type" => "text/html" }, ["OK"]]
end
run app