cd ~/.password-store

for gpg in $(find . -type f -name "*.gpg")
do
  echo -e "\n\n${gpg}\n---------------------------------------------"

  gpg2 --decrypt "${gpg}" 2>/dev/null \
  | gpg2 --no-throw-keyids --encrypt -r 0xB1C024F6 --output "/tmp/${gpg##*/}"

  mv "/tmp/${gpg##*/}" "${gpg}"
done

#git commit -a -m "--no-throw-keyids"
#git push
