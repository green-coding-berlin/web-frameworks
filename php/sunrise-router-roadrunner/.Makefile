build:
	 cd php/sunrise-router-roadrunner && docker build -f .Dockerfile.road-runner -t php.sunrise-router-roadrunner.road-runner .&& cd -
	 docker run -p 3000:3000 -td php.sunrise-router-roadrunner.road-runner
	 sleep 5
	 echo '127.0.0.1' > php/sunrise-router-roadrunner/ip-road-runner.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/sunrise-router-roadrunner/ip-road-runner.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/sunrise-router-roadrunner/ip-road-runner.txt` ENGINE=road-runner LANGUAGE=php FRAMEWORK=sunrise-router-roadrunner DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.sunrise-router-roadrunner.road-runner  | xargs docker rm -f
run-all : build.road-runner collect.road-runner clean.road-runner
