update_ddg_bangs:
	curl -v 'https://duckduckgo.com/bang.v260.js' \
		-H 'Accept: application/json, text/javascript, */*; q=0.01' \
		-H 'Referer: https://duckduckgo.com/' \
		-H 'Sec-Fetch-Dest: empty' \
		-H 'X-Requested-With: XMLHttpRequest' \
		-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.15.0 Chrome/80.0.3987.163 Safari/537.36' \
		--compressed | jq > data/ddg_bangs.json
