build:
	 cd javascript/koa && docker build -f .Dockerfile.node -t javascript.koa.node .&& cd -
	 docker run -p 3000:3000 -td javascript.koa.node
	 sleep 5
	 echo '127.0.0.1' > javascript/koa/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/koa/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/koa/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=koa DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.koa.node  | xargs docker rm -f
run-all : build.node collect.node clean.node