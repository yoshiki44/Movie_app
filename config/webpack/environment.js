const { environment } = require('@rails/webpacker')

// Webpack 5 以降で不要な Node.js コアモジュールを無効化
environment.config.merge({
  resolve: {
    fallback: {
      fs: false,
      net: false,
      tls: false,
      child_process: false,
      dgram: false
    }
  }
})

module.exports = environment
