build:
	 cd javascript/0http && docker build -f .Dockerfile.node -t javascript.0http.node .&& cd -
	 docker run -p 3000:3000 -td javascript.0http.node
	 sleep 5
	 echo '127.0.0.1' > javascript/0http/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/0http/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/0http/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=0http DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.0http.node  | xargs docker rm -f
run-all : build.node collect.node clean.node