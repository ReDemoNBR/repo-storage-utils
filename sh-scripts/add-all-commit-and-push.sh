git add -A
git commit -m $1
if [ -z $2 ]
    then git push
else git checkout -b $2 ; git push origin $2
fi