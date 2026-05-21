const NodeMediaServer = require('node-media-server');

const config = {
  rtmp: {
    port: 1935,
    chunk_size: 60000,
    gop_cache: true,
    ping: 10,
    ping_timeout: 30
  },
  http: {
    port: 8000,
    allow_origin: '*',
    mediaroot: './media'
  },
  auth: {
    api: false
  }
};

var nms = new NodeMediaServer(config);
nms.run();
