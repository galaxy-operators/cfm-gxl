beta_num=1 
while git rev-parse "v${VERSION}-beta.${beta_num}" >/dev/null 2>&1; do 
    beta_num=$((beta_num+1)); 
done 
git tag "v${VERSION}-beta.${beta_num}" 
git push --tags