# You can find frp releases at: https://github.com/fatedier/frp/releases (darwin=MacOS)
frpsVersion=https://github.com/fatedier/frp/releases/download/v0.37.1/frp_0.37.1_linux_amd64.tar.gz
frpcVersion=https://github.com/fatedier/frp/releases/download/v0.37.1/frp_0.37.1_darwin_amd64.tar.gz

sinclude ./config/.env.client
sinclude ./config/.env.server

help:
	@echo '🐲 Fast Reverse Proxy cli. Commands:'
	@echo '	server-init: initialize frp server executable.'
	@echo '	server-env: initialize and/or edit frp server env.'
	@echo '	server-start: start frp server.'
	@echo ' client-init: initialize frp client executable.'
	@echo '	client-env: initialize and/or edit frp client env.'
	@echo '	client-start: start frp client to connect to the frp server.'

server-env: 
	@read -p "reset .env type 'RESET', else continue (RESET|*)? : " RESET && \
	if [ "$$RESET" == "RESET" ]; then \
		cp ./config/.env.server.example ./config/.env.server ; \
	fi
	@if [ ! -f "./config/.env.server" ]; then \
		cp ./config/.env.server.example ./config/.env.server ; \
	fi
	vim ./config/.env.server ; \

client-env: 
	@read -p "reset .env type 'RESET', else continue (RESET|*)? : " RESET && \
	if [ "$$RESET" == "RESET" ]; then \
		cp ./config/.env.client.example ./config/.env.client ; \
	fi
	@if [ ! -f "./config/.env.client" ]; then \
		cp ./config/.env.client.example ./config/.env.client ; \
	fi
	vim ./config/.env.client ; \

server-init:	
	@if [ ! -f "./config/frps" ]; then \
		echo '🐲 Downloading latest FRPS version <$(frpsVersion)>' && \
		curl -L $(frpsVersion) > frps.tar.gz && \
		gzip -d frps.tar.gz && \
		mkdir frps &&  tar -xf frps.tar -C ./frps --strip-components 1 && \
		rm frps.tar && \
		mv ./frps/frps ./config/frps && \
		rm -rf frps; \
	else \
		echo '🐲 Skipped initialize Server, ./config/frps exec already exists'; \
	fi

client-init:
	@if [ ! -f "./config/frpc" ]; then \
		echo '🐲 Downloading latest FRPC version <$(frpcVersion)>' && \
		curl -L $(frpcVersion) > frpc.tar.gz && \
		gzip -d frpc.tar.gz && \
		mkdir frpc &&  tar -xf frpc.tar -C ./frpc --strip-components 1 && \
		rm frpc.tar && \
		mv ./frpc/frps ./config/frpc && \
		rm -rf frpc; \
	else \
		echo '🐲 Skipped initialize Client, ./config/frpc exec already exists'; \
	fi

server-start:
	@echo '🐲 Starting FRPS'
	@if [ -f "./config/.env.server" ]; then \
		export FRP_CLIENT_BIND_PORT=$(FRP_CLIENT_BIND_PORT) && \
		export FRP_CLIENT_TOKEN=$(FRP_CLIENT_TOKEN) && \
		./config/frps -c ./config/frps.ini ; \
	else \
		echo '🐲 Missing .env.server file in config. Create on by running server-init'; \
	fi
	

client-start:
	@echo '🐲 Starting FRPC';
	@if [ -f "./config/.env.client" ]; then \
		export FRP_SERVER_ADDR=$(FRP_SERVER_ADDR) && \
		export FRP_SERVER_PORT=$(FRP_SERVER_PORT) && \
		export FRP_SERVER_TOKEN=$(FRP_SERVER_TOKEN) && \
		export FRP_SERVER_SSH_TYPE=$(FRP_SERVER_SSH_TYPE) && \
		export FRP_SERVER_SSH_LOCAL_PORT=$(FRP_SERVER_SSH_LOCAL_PORT) && \
		export FRP_SERVER_SSH_LOCAL_IP=$(FRP_SERVER_SSH_LOCAL_IP) && \
		export FRP_SERVER_SSH_REMOTE_PORT=$(FRP_SERVER_SSH_REMOTE_PORT) && \
		./config/frpc -c ./config/frpc.ini ; \
	else \
		echo '🐲 Missing .env.client file in config. Create on by running client-init'; \
	fi
	