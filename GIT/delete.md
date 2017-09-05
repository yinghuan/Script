#Delete the file from a checkout
Github has a [useful page](https://help.github.com/articles/removing-sensitive-data-from-a-repository/) how to permanently delete file(s) from a repository, in brief:

```
$ git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch 200MB-filename' \
  --prune-empty --tag-name-filter cat -- --all
$ git push --all -f
```

That would remove the file from all branches. Then to recover the space locally:

```
$ rm -rf .git/refs/original/
$ git reflog expire --expire=now --all
$ git gc --prune=now
```

#Recovering space on the git server
Force pushing does not remove any commits/objects on the remote server. If you don't want to wait for git to clean up itself, you can run it explicitly on the server:

```
$ ssh git server
$ cd /my/project/repo.git
$ git gc --prune=now
```
Compare the size of the repo before and after - ensure that it is the size you expect. If at any time in the future it reverts to the larger size - someone has pushed the deleted commits back into the repository (need to do all steps again).

#Teammates

If there are other developers using this repository - they will need to clean up their checkouts. Otherwise when they pull from the repository and push their changes they will add back the deleted file as it's still in their local history. There are two ways to avoid that:

1. Clone again  
2. fetch and reset

The first is very simple, the second means one of two things:

##User has no local commits

```
$ git fetch
$ git reset origin/master --hard
```
That would make any local checkout exactly match the remote

##User does have local commits

```
$ git fetch
$ git rebase -i origin/master
```
The user needs to make sure they don't have any local commits referencing the delete file - or they'll add it back to the repository.

##User cleanup

Then (optionally, because git won't push unreferenced commits to the server) recover space, and everyone has a consistent slimmer repository state:

```
$ rm -rf .git/refs/original/
$ git reflog expire --expire=now --all
$ git gc --prune=now
```
