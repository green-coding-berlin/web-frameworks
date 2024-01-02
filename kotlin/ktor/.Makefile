build:
	 cd kotlin/ktor && docker build -f .Dockerfile.default -t kotlin.ktor.default .&& cd -
	 docker run -p 3000:3000 -td kotlin.ktor.default
	 sleep 5
	 echo '127.0.0.1' > kotlin/ktor/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat kotlin/ktor/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat kotlin/ktor/ip-default.txt` ENGINE=default LANGUAGE=kotlin FRAMEWORK=ktor DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=kotlin.ktor.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
