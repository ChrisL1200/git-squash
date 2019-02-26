
while getopts b:c: option
do
case "${option}"
in
b) SOURCE_BRANCH=${OPTARG};;
c) COMMIT=${OPTARG};;
esac
done

if [ -z "$SOURCE_BRANCH" ]
then
echo "You must specify a source branch (i.e spin-09) using './preMerge.sh -b <source_branch_name> -c <commit_message>'"
exit 1
fi

if [ -z "$COMMIT" ]
then
echo "You must specify a commit message. './preMerge.sh -b <source_branch_name> -c <commit_message>'"
exit 1
fi

# - Rev version in package.json up by 1.
node preMerge.js
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')
git add --all
git commit -m $COMMIT

# - Squash commits
git rebase -i $SOURCE_BRANCH

# - Generate changelog
rm -f CHANGELOG.md
npm run changelog
git add --all
git commit -m "Updated changelog"

# - Squash again
git rebase -i $SOURCE_BRANCH

# - tag repo based on new version 
git tag $PACKAGE_VERSION
git push origin $PACKAGE_VERSION
CURRENT_BRANCH=$(git branch)
git push origin --force
