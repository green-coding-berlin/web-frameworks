build:
	 cd java/blade && docker build -f .Dockerfile.default -t java.blade.default .&& cd -
	 docker run -p 3000:3000 -td java.blade.default
	 sleep 5
	 echo '127.0.0.1' > java/blade/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/blade/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/blade/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=blade DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.blade.default  | xargs docker rm -f
run-all : build.default collect.default clean.default