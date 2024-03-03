build:
	docker build -t dlv .

build-without-cache:
	docker build --no-cache -t dlv .

run:
	docker run \
		--rm \
		-p 8080:8080 \
		-p 8081:8081 \
		--security-opt seccomp:unconfined \
		--cap-add=SYS_PTRACE \
		--name dlv \
		dlv \
		bash -c 'dlv exec ./server --headless --continue --accept-multiclient --listen :8081'

kill:
	docker kill dlv

update.init.lua:
	rm -rf ~/.config/nvim
	cp -r .devcontainer/config/nvim ~/.config/nvim
