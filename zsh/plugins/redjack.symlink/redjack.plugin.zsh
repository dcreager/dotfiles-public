if [[ -d /opt/redjack/bin ]]; then
   path=(/opt/redjack/bin $path)
fi

if [[ -f /opt/redjack/etc/epkg.conf ]]; then
    source /opt/redjack/etc/epkg.conf
fi
