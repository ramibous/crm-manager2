if Rails.env.production?
  WickedPdf.config = {
    exe_path: '/app/bin/wkhtmltopdf' # Heroku path for wkhtmltopdf
  }
else
  WickedPdf.config = {
    exe_path: '/Users/ramiboussarsar/.rbenv/shims/wkhtmltopdf' # Your local path
  }
end
