build:
	docker build -t rails-dap .

run:
	docker run \
		--rm \
		-p 3000:3000 \
		-p 12345:12345 \
		--security-opt seccomp:unconfined \
		--cap-add=SYS_PTRACE \
		--name rails-dap \
		rails-dap \
		bash -c 'rdbg -n -O --host 0.0.0.0 --port 12345 -c -- bundle exec rails server -p 3000 -b 0.0.0.0'
