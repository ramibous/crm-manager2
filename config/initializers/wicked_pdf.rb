if Rails.env.production?
  WickedPdf.configure do |config|
    config.exe_path = '/app/bin/wkhtmltopdf' # Heroku path for wkhtmltopdf
  end
else
  WickedPdf.configure do |config|
    config.exe_path = '/Users/ramiboussarsar/.rbenv/shims/wkhtmltopdf' # Your local path
  end
end
