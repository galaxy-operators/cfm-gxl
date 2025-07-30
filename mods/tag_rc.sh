rc_num=1 
while git rev-parse "v${VERSION}-rc.${rc_num}" >/dev/null 2>&1; do 
    rc_num=$((rc_num+1)); 
done 
git tag "v${VERSION}-rc.${rc_num}" 
git push --tags