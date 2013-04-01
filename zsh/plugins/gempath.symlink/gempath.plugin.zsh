if [[ -d ~/.gem/ruby/1.9.1/bin ]]; then
   path=(~/.gem/ruby/1.9.1/bin $path)
fi
if [[ -d ~/.gem/ruby/2.0.0/bin ]]; then
   path=(~/.gem/ruby/2.0.0/bin $path)
fi
