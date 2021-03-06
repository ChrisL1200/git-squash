
while getopts b: option
do
case "${option}"
in
b) SOURCE_BRANCH=${OPTARG};;
esac
done

if [ -z "$SOURCE_BRANCH" ]
then
echo "You must specify a source branch (i.e spin-09) using './preMerge.sh -b <source_branch_name>'"
exit 1
fi

# - Rev version in package.json up by 1.
node preMerge.js
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

# - Squash commits
git rebase -i $SOURCE_BRANCH

# - Generate changelog
rm -f CHANGELOG.md
npm run changelog

# - Squash again
git rebase -i $SOURCE_BRANCH

# - tag repo based on new version 
git tag $PACKAGE_VERSION
git push origin $PACKAGE_VERSION
CURRENT_BRANCH=$(git branch)
git push origin --force
