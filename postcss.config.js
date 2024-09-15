module.exports = {
    plugins: [
      require('autoprefixer')({
        overrideBrowserslist: ['last 2 versions'],
        flexbox: 'no-2009',
        remove: false // Prevents removing deprecated properties like color-adjust
      })
    ]
  };
  