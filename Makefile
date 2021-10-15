frpVersion=https://github.com/fatedier/frp/releases/download/v0.37.1/frp_0.37.1_linux_amd64.tar.gz

init:	
	@if [ ! -d "frp" ]; then \
		echo '🐲 Downloading latest FRPS version <$(frpVersion)>' && \
		curl -L $(frpVersion) > frps.tar.gz && \
		gzip -d frps.tar.gz && \
		mkdir frps &&  tar -xf frps.tar -C ./frps --strip-components 1 && \
		rm frps.tar; \
	fi

start:
	echo '🐲 Starting FRPS'
	./frps/frps -c ./frps/frps.ini
	