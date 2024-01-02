build:
	 cd crystal/athena && docker build -f .Dockerfile.default -t crystal.athena.default .&& cd -
	 docker run -p 3000:3000 -td crystal.athena.default
	 sleep 5
	 echo '127.0.0.1' > crystal/athena/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat crystal/athena/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat crystal/athena/ip-default.txt` ENGINE=default LANGUAGE=crystal FRAMEWORK=athena DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=crystal.athena.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
