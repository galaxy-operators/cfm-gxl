alpha_num=1 
while git rev-parse "v${VERSION}-alpha.${alpha_num}" >/dev/null 2>&1; do 
    alpha_num=$((alpha_num+1)); 
done 
git tag "v${VERSION}-alpha.${alpha_num}" 
git push --tags