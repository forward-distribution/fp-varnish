To locally test the ESI tags integration do the following:

1. Start the mock ESI server 

By default it's set to return the current ISO date - this is useful for testing TTL and grace periods
```sh
node local-esi-testing/mock-esi.js
```

2. Start a Varnish instance configured for testing the ESI tags
```sh
docker-compose -f ./docker-compose.local-esi-testing.yml up -d 
```

3. To see its logs:
```sh
# shell into it
docker exec -it fp-varnish-esi-tests sh

# and run varnishlog, for example
varnishlog -q 'RespStatus >= 500 or BerespStatus >= 500"'
```
 
4. In the delivery configure the local.js to point to the mock-esi server

```js
// conf/environments/local.js
  externalScripts: {
    enabled: true,
    urls: {
      // separate server for ESI tags - better reflective of non-local environments
      head: 'http://host.docker.internal:4444/external-scripts/head',
      bodyTop: 'http://host.docker.internal:4444/external-scripts/body-top',
      bodyBottom: 'http://host.docker.internal:4444/external-scripts/body-bot',
    },
  },
```

5. Accessing localhost:1111/delivery-pathname should now give you back delivery + ESI content
