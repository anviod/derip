
### 1 build docker

```
docker build -t derper:least .
```

### 2 run docker

> docker run   --name derper -p 18443:443 -p 3478:3478/udp {docker-id} 
```
docker run --rm -d --restart unless-stopped  --name derper -p 18443:443 -p 3478:3478/udp {docker-id}

[root@PTT_Server ~]# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                            NAMES
fba73fb44d31   0a52      "/bin/sh -c '/app/de…"   5 seconds ago   Up 5 seconds   0.0.0.0:3478->3478/udp, 0.0.0.0:18443->443/tcp   heuristic_mccarthy

```


### 3 config Derper [tailscale_acls](https://login.tailscale.com/admin/acls/file)

add
```
	"derpMap": {
		"Regions": {
			"901": {
				"RegionID":   901,
				"RegionCode": "iCd",
				"RegionName": "Hong Kong",
				"Nodes": [
					{
						"Name":             "901a",
						"RegionID":         901,
						"DERPPort":         18443,
						"HostName":         "{ replace YOU PUBLIC IP 1.2.3.4}",
						"IPv4":             "{ replace YOU PUBLIC IP 1.2.3.4}",
						"InsecureForTests": true,
					},
				],
			},
		},
	}
```

### 4  tailscale netcheck

```
[root@PTT_Server ~]# tailscale netcheck

Report:
        * Time: 2024-12-06T08:21:13.6386916Z
        * UDP: true
        * IPv4: yes, 118.193.244.157:9530
        * IPv6: yes, [2408:8f56:680:941b:a87b:8a2a:f0e1:76d2]:58042
        * MappingVariesByDestIP: true
        * PortMapping:
        * CaptivePortal: false
        * Nearest DERP: Hong Kong
        * DERP latency:
                - iCd: 25ms    (Hong Kong)
                - tok: 149.1ms (Tokyo)
                - nue: 170.3ms (Nuremberg)
                - sfo: 180.3ms (San Francisco)
                - lax: 180.3ms (Los Angeles)
                - sin: 195.2ms (Singapore)
                - den: 201.7ms (Denver)
                - sea: 206.9ms (Seattle)
                - dfw: 226ms   (Dallas)
                - ord: 226ms   (Chicago)
                - tor: 226ms   (Toronto)
                - fra: 227.6ms (Frankfurt)
                - lhr: 239.4ms (London)
                - iad: 245.5ms (Ashburn)
                - mia: 245.5ms (Miami)
                - nyc: 246.1ms (New York City)
                - hnl: 246.6ms (Honolulu)
                - par: 247ms   (Paris)
                - ams: 255.8ms (Amsterdam)
                - blr: 260.4ms (Bangalore)
                - mad: 260.8ms (Madrid)
                - waw: 261.5ms (Warsaw)
                - dbi: 337.7ms (Dubai)
                - sao: 359.7ms (São Paulo)
                - syd: 407.5ms (Sydney)
                - jnb: 422.9ms (Johannesburg)
                - nai: 525.9ms (Nairobi)
```


### 5 ping test  Tokyo VS Hong Kong

```
[root@PTT_Server ~]# tailscale ping 172.18.176.54
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 741ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 405ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 397ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 412ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 427ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 401ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 394ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 398ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 400ms
pong from tailscale-client-test (172.18.176.54) via DERP(tok) in 398ms

[root@PTT_Server ~]# tailscale ping 172.18.176.54
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 54ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 71ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 66ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 68ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 66ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 61ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 74ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 62ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 59ms
pong from tailscale-client-test (172.18.176.54) via DERP(iCd) in 75ms
direct connection not established
```