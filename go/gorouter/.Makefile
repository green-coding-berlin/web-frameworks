build:
	 cd go/gorouter && docker build -f .Dockerfile.net-http -t go.gorouter.net-http .&& cd -
	 docker run -p 3000:3000 -td go.gorouter.net-http
	 sleep 5
	 echo '127.0.0.1' > go/gorouter/ip-net-http.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/gorouter/ip-net-http.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/gorouter/ip-net-http.txt` ENGINE=net-http LANGUAGE=go FRAMEWORK=gorouter DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.gorouter.net-http  | xargs docker rm -f
run-all : build.net-http collect.net-http clean.net-http